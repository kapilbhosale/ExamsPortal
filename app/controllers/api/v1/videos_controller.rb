# frozen_string_literal: true

class Api::V1::VideosController < Api::V1::ApiController
  skip_before_action :authenticate, only: [:set_yt_url, :get_ytdlp_url_from_youtube]

  def index
    lectures = VideoLecture.includes(:batches, :subject)
      .where(batches: {id: current_student.batches})
      .where(enabled: true)
      .order(id: :desc)

    tracker_by_id = Tracker.where(student_id: current_student.id, resource_type: 'VideoLecture').index_by(&:resource_id)
    lectures_data = {}
    lectures.each do |lect|
      next if lect.publish_at.present? && lect.publish_at > Time.current

      lect_data = lect.attributes.slice("id" ,"title", "url", "video_id", "description", "by", "tag", "subject_id", "video_type", "tp_streams_id")
      lect_data['thumbnail_url'] = lect.vimeo? ? lect.thumbnail : lect.uploaded_thumbnail.url
      lect_data['added_ago'] = helpers.time_ago_in_words(lect.publish_at || lect.created_at)
      if lect.vimeo?
        lect_data['play_url'] = "#{helpers.full_domain_path}/students/lectures/#{lect.video_id}"
      else
        lect_data['play_url'] = lect.url
      end

      lect_data['views_count'] = tracker_by_id[lect.id].present? ? tracker_by_id[lect.id].data['view_count'] : 0
      lect_data['total_views_count'] = tracker_by_id[lect.id].present? ? tracker_by_id[lect.id].data['allocated_views'] || lect.view_limit : lect.view_limit || 10000
      lect_data['tp_streams_data'] = lect.tp_streams_json

      lectures_data[lect.subject&.name] ||= []
      lectures_data[lect.subject&.name] << lect_data
    end

    render json: lectures_data, status: :ok
  end

  # def set_yt_url
  #   lecture = VideoLecture.find_by(id: params[:video_id])
  #   render json: {} and return if lecture.blank?

  #   urls = params[:urls]
  #   expiry_time = params[:expiry_time]

  #   cached_url = REDIS_CACHE.get("lecture-#{lecture.id}")
  #   if cached_url.blank?s
  #     cached_url = yt_url(lecture)
  #     REDIS_CACHE.set("lecture-#{lecture.id}", cached_url, { ex: (10 * 60) })
  #     # expiry_time.
  #   end

  #   render json: { url_hd: cached_url, url_sd: cached_url }
  # end

  def need_url
    lecture = VideoLecture.find_by(id: params[:video_id])
    if lecture.present? && lecture.play_url_expired?
      VideoLinkFetchWorker.perform_async(lecture.id)
    end
    render json: {}, status: :ok
  end

  def get_ytdlp_url
    lecture = VideoLecture.find_by(id: params[:video_id])
    if lecture.present?
      lecture.update_play_url if lecture.play_url_expired?
      render json: { url_hd: lecture.play_url_from_server, url_sd: lecture.play_url_from_server }, status: :ok and return
    end
    # IMP:: Remove later, VAA fix.
    # VideoLinkFetchWorker.perform_async(lecture.id)
    render json: { url_hd: nil, url_sd: nil }, status: :ok
  end

  def get_ytdlp_url_from_youtube
    video_data = `yt-dlp --get-url --format 18/22 '#{params[:video_id]}' --proxy #{Proxy.random}`
    # video_data = `yt-dlp --get-url --format 18/22 '#{params[:video_id]}' --proxy #{PROXIES[Random.rand(999)]}`
    render json: {url: video_data&.squish }
  end

  # deprecated, remote it.
  def get_yt_url
    lecture = VideoLecture.find_by(id: params[:video_id])
    render json: { url_hd: nil, url_sd: nil } and return if lecture.blank?

    cached_url_sd = REDIS_CACHE.get("lecture-#{lecture.id}-url_sd")
    cached_url_sd_contentLength = REDIS_CACHE.get("lecture-#{lecture.id}-url_sd_contentLength")
    cached_url_hd = REDIS_CACHE.get("lecture-#{lecture.id}-url_hd")
    cached_url_hd_contentLength = REDIS_CACHE.get("lecture-#{lecture.id}-url_hd_contentLength")

    if cached_url_sd.blank?
      if ['exams', 'rcc'].include?(request.subdomain)
        json_data = {
          url_sd: "",
          url_sd_contentLength: "",
          url_hd: "",
          url_hd_contentLength: ""
        }
        render json: json_data and return
      end
      yt_json = yt_json_info(lecture)
      REDIS_CACHE.set("lecture-#{lecture.id}-url_sd", yt_json['url'], { ex: 1.hour })
      REDIS_CACHE.set("lecture-#{lecture.id}-url_sd_contentLength", yt_json['filesize'])
      json_data = {
        url_sd: yt_json['url'],
        url_sd_contentLength: yt_json['filesize'],
        url_hd: yt_json['url'],
        url_hd_contentLength: yt_json['filesize'],
      }
      render json: json_data
    else
      json_data = {
        url_sd: cached_url_sd,
        url_sd_contentLength: cached_url_sd_contentLength,
        url_hd: cached_url_hd,
        url_hd_contentLength: cached_url_hd_contentLength
      }
      render json: json_data
    end
  end

  def set_yt_url
    lecture = VideoLecture.find_by(id: params[:video_id])
    render json: {} and return if lecture.blank?

    REDIS_CACHE.set("lecture-#{lecture.id}-url_sd", params[:urls][:url_sd], { ex: 1.hour })
    REDIS_CACHE.set("lecture-#{lecture.id}-url_sd_contentLength", params[:urls][:url_sd_contentLength])
    REDIS_CACHE.set("lecture-#{lecture.id}-url_hd", params[:urls][:url_hd], { ex: 1.hour })
    REDIS_CACHE.set("lecture-#{lecture.id}-url_hd_contentLength", params[:urls][:url_hd_contentLength])

    render json: { status: 'ok' }
  end

  def categories
    if current_org.subdomain == 'exams' && current_student.pending_amount.present? && current_student.block_videos?
      render json: {}, status: :ok and return
    end

    student_video_folders = StudentVideoFolder.where(student_id: current_student.id)
    cache_key = "VF-#{current_student.batches.order(:id).ids.join('-')}"
    cached_data = REDIS_CACHE.get(cache_key)

    if student_video_folders.blank? && cached_data.present?
      render json: JSON.parse(cached_data), status: :ok and return
    end

    all_vls = VideoLecture
      .includes(:genre, :subject, :batches)
      .where(org_id: current_org.id)
      .where(batches: { id: current_student.batches.ids })

    video_lectures = all_vls.where(enabled: true)
    categories_data = {}

    video_lectures.each do |vl|
      next if vl.publish_at.present? && vl.publish_at > Time.current

      subject_name = vl.subject&.name
      categories_data[subject_name] ||= {}
      categories_data[subject_name][vl.genre_id] ||= {
        id: vl.genre_id,
        name: vl&.genre&.name || 'Default',
        count: 0,
        new: 0
      }
      categories_data[subject_name][vl.genre_id][:count] += 1
      if vl.created_at >= Time.zone.now.beginning_of_day
        categories_data[subject_name][vl.genre_id][:new] += 1
      end
    end

    if student_video_folders.blank?
      REDIS_CACHE.set(cache_key, categories_data.to_json, { ex: 1.day })
      render json: categories_data, status: :ok and return
    end

    # considering enalbed false videos for students admitted late.
    # starts here

    video_lectures = all_vls.where(enabled: false)
    video_lectures.each do |vl|
      next if vl.publish_at.present? && vl.publish_at > Time.current

      svfs = student_video_folders.index_by(&:genre_id)
      svf = svfs[vl&.genre&.id]

      include_flag = false
      if svf.present? && svf.show_till_date.to_date >= Date.today
        include_flag = true
      else
        genre_date = vl&.publish_at || vl&.created_at.to_date
        student_active_date = current_student.created_at
        include_flag = true if student_active_date > genre_date && student_active_date.to_date + 30.days >= Date.today
      end

      next unless include_flag

      subject_name = vl.subject&.name
      categories_data[subject_name] ||= {}
      categories_data[subject_name][vl.genre_id] ||= {
        id: vl.genre_id,
        name: vl&.genre&.name || 'Default',
        count: 0,
        new: 0
      }
      categories_data[subject_name][vl.genre_id][:count] += 1
      if vl.created_at >= Time.zone.now.beginning_of_day
        categories_data[subject_name][vl.genre_id][:new] += 1
      end
    end
    # considering enalbed false videos for students admitted late.
    # ends here

    json_data = categories_data
    render json: json_data, status: :ok
  end

  def category_videos
    student_video_folders = StudentVideoFolder.where(student_id: current_student.id)
    cache_key = "CV-#{params[:id]}"
    cached_data = REDIS_CACHE.get(cache_key)

    # if student_video_folders.blank? && cached_data.present?
    #   render json: JSON.parse(cached_data), status: :ok and return
    # end

    all_vls = VideoLecture.includes(:batches)
              .where(org_id: current_org.id)
              .where(batches: {id: current_student.batches.ids}, genre_id: params[:id].to_i)

    video_lectures = all_vls.where(enabled: true).order(id: :desc)

    lectures_json = lectures_json(video_lectures)
    lectures_json = lectures_json.delete_if { |_, value| value.blank? }

    if student_video_folders.blank?
      REDIS_CACHE.set(cache_key, lectures_json.to_json, { ex: 1.day })
      render json: lectures_json, status: :ok and return
    end
    # considering enalbed false videos for students admitted late.
    # starts here

    disabled_vls = all_vls.where(enabled: false).order(id: :desc)

    disabled_vls.each do |vl|
      next if vl.publish_at.present? && vl.publish_at > Time.current

      svfs = student_video_folders.index_by(&:genre_id)
      svf = svfs[vl&.genre&.id]

      include_flag = false
      if svf.present? && svf.show_till_date.to_date >= Date.today
        include_flag = true
      else
        genre_date = vl&.publish_at || vl&.created_at.to_date
        student_active_date = current_student.created_at
        include_flag = true if student_active_date > genre_date && student_active_date.to_date + 30.days >= Date.today
      end

      next unless include_flag
      lect = vl
      lect_data = lect.attributes.slice("id" ,"title", "url", "video_id", "description", "by", "tag", "subject_id", "video_type", "tp_streams_id")
      lect_data['thumbnail_url'] = lect.vimeo? ? lect.thumbnail : lect.uploaded_thumbnail.url
      lect_data['added_ago'] = helpers.time_ago_in_words(lect.publish_at || lect.created_at)
      if lect.vimeo?
        lect_data['play_url'] = "#{helpers.full_domain_path}/students/lectures/#{lect.video_id}"
      else
        lect_data['play_url'] = lect.url
      end
      lectures_json[lect.subject&.name] ||= []
      lectures_json[lect.subject&.name] << lect_data
    end

    render json: lectures_json, status: :ok
  end

  private

  def yt_json_info(lecture)
    video_data = `youtube-dl -j --format 18/22 '#{lecture.url}'`
    return JSON.parse(video_data) if video_data.present?

    video_data_from_proxy = `youtube-dl -j --format 18/22 '#{lecture.url}' --proxy #{Proxy.random}`
    JSON.parse(video_data_from_proxy) if video_data_from_proxy.present?
  end

  def lectures_json(lectures)
    lectures_data = {}
    lectures.each do |lect|
      next if lect.publish_at.present? && lect.publish_at > Time.current

      lect_data = lect.attributes.slice("id" ,"title", "url", "video_id", "description", "by", "tag", "subject_id", "video_type", "play_url_from_server", "tp_streams_id")
      lect_data['thumbnail_url'] = lect.vimeo? ? lect.thumbnail : lect.uploaded_thumbnail.url
      lect_data['added_ago'] = helpers.time_ago_in_words(lect.publish_at || lect.created_at)
      if lect.vimeo?
        lect_data['play_url'] = "#{helpers.full_domain_path}/students/lectures/#{lect.video_id}"
      else
        lect_data['play_url'] = lect.url
      end

      if lect.play_url_expired?
        lect_data['play_url_from_server'] = nil
      end

      lect_data['player'] = {
        use_first: 'tp_streams', #'custom|tp_streams'
        on_error: (request.headers['buildNumber'].to_i >= 87 ? 'youtube' : nil)
      }

      lectures_data[lect.subject&.name] ||= []
      lectures_data[lect.subject&.name] << lect_data
    end
    lectures_data
  end
end
