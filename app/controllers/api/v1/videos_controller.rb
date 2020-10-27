# frozen_string_literal: true

class Api::V1::VideosController < Api::V1::ApiController
  skip_before_action :verify_authenticity_token, only: [:set_yt_url]

  def index
    lectures = VideoLecture.includes(:batches, :subject)
      .where(batches: {id: current_student.batches})
      .where(enabled: true)
      .order(id: :desc)

    tracker_by_id = Tracker.where(student_id: current_student.id, resource_type: 'VideoLecture').index_by(&:resource_id)
    lectures_data = {}
    lectures.each do |lect|
      next if lect.publish_at.present? && lect.publish_at > Time.current

      lect_data = lect.attributes.slice("id" ,"title", "url", "video_id", "description", "by", "tag", "subject_id", "video_type")
      lect_data['thumbnail_url'] = lect.vimeo? ? lect.thumbnail : lect.uploaded_thumbnail.url
      lect_data['added_ago'] = helpers.time_ago_in_words(lect.created_at)
      if lect.vimeo?
        lect_data['play_url'] = "#{helpers.full_domain_path}/students/lectures/#{lect.video_id}"
      else
        lect_data['play_url'] = lect.url
      end

      lect_data['views_count'] = tracker_by_id[lect.id].present? ? tracker_by_id[lect.id].data['view_count'] : 0
      lect_data['total_views_count'] = tracker_by_id[lect.id].present? ? tracker_by_id[lect.id].data['allocated_views'] || lect.view_limit : lect.view_limit || 10000

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
  #   if cached_url.blank?
  #     cached_url = yt_url(lecture)
  #     REDIS_CACHE.set("lecture-#{lecture.id}", cached_url, { ex: (10 * 60) })
  #     # expiry_time.
  #   end

  #   render json: { url_hd: cached_url, url_sd: cached_url }
  # end

  def get_yt_url
    lecture = VideoLecture.find_by(id: params[:video_id])
    render json: { url_hd: nil, url_sd: nil } and return if lecture.blank?

    cached_url_sd = REDIS_CACHE.get("lecture-#{lecture.id}-url_sd")
    cached_url_sd_contentLength = REDIS_CACHE.get("lecture-#{lecture.id}-url_sd_contentLength")
    cached_url_hd = REDIS_CACHE.get("lecture-#{lecture.id}-url_hd")
    cached_url_hd_contentLength = REDIS_CACHE.get("lecture-#{lecture.id}-url_hd_contentLength")
  
    if cached_url_sd.blank?
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
    video_lectures = VideoLecture
      .includes(:genre, :subject, :batches)
      .where(org_id: current_org.id)
      .where(batches: { id: current_student.batches.ids })
      .where(enabled: true)
    categories_data = {}
    video_lectures.all.each do |vl|
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
    json_data = categories_data
    render json: json_data, status: :ok
  end

  def category_videos
    video_lectures = VideoLecture.includes(:batches)
                                 .where(org_id: current_org.id)
                                 .where(batches: {id: current_student.batches.ids}, genre_id: params[:id].to_i)
                                 .where(enabled: true)
                                 .order(id: :desc)
    lectures_json = lectures_json(video_lectures)
    lectures_json = lectures_json.delete_if { |_, value| value.blank? }

    render json: lectures_json, status: :ok
  end

  private

  def proxy_list
    [
      'mvjxvmzc-dest:l15yq4x69d27@  193.8.231.228:80',
      'mvjxvmzc-dest:l15yq4x69d27@198.154.92.15:80',
      'mvjxvmzc-dest:l15yq4x69d27@144.168.151.68:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.140.14.97:80',
      'mvjxvmzc-dest:l15yq4x69d27@193.23.245.218:80',
      'mvjxvmzc-dest:l15yq4x69d27@193.5.65.172:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.154.84.146:80',
      'mvjxvmzc-dest:l15yq4x69d27@185.164.57.199:80',
      'mvjxvmzc-dest:l15yq4x69d27@23.229.119.73:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.141.176.155:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.136.231.197:80',
      'mvjxvmzc-dest:l15yq4x69d27@192.241.94.23:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.80.131:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.131.212.193:80',
      'mvjxvmzc-dest:l15yq4x69d27@193.5.251.231:80',
      'mvjxvmzc-dest:l15yq4x69d27@104.227.101.209:80',
      'mvjxvmzc-dest:l15yq4x69d27@185.250.39.249:80',
      'mvjxvmzc-dest:l15yq4x69d27@193.27.19.14:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.158.185.214:80',
      'mvjxvmzc-dest:l15yq4x69d27@107.152.197.209:80',
    ]
  end

  def yt_json_info(lecture)
    video_data = `youtube-dl -j --format 18/22 '#{lecture.url}'`
    return JSON.parse(video_data) if video_data.present?

    video_data_from_proxy = `youtube-dl -j --format 18/22 '#{lecture.url}' --proxy #{proxy_list[Random.rand(19)]}`
    JSON.parse(video_data_from_proxy)
  end

  def lectures_json(lectures)
    lectures_data = {}
    lectures.each do |lect|
      next if lect.publish_at.present? && lect.publish_at > Time.current

      lect_data = lect.attributes.slice("id" ,"title", "url", "video_id", "description", "by", "tag", "subject_id", "video_type")
      lect_data['thumbnail_url'] = lect.vimeo? ? lect.thumbnail : lect.uploaded_thumbnail.url
      lect_data['added_ago'] = helpers.time_ago_in_words(lect.created_at)
      if lect.vimeo?
        lect_data['play_url'] = "#{helpers.full_domain_path}/students/lectures/#{lect.video_id}"
      else
        lect_data['play_url'] = lect.url
      end
      lectures_data[lect.subject&.name] ||= []
      lectures_data[lect.subject&.name] << lect_data
    end
    lectures_data
  end
end
