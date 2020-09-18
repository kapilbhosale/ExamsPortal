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

  def set_yt_url
    lecture = VideoLecture.find_by(id: params[:video_id])
    render json: {} and return if lecture.blank?

    cached_url = REDIS_CACHE.set("lecture-#{lecture.id}")
    if cached_url.blank?
      cached_url = yt_url(lecture)
      REDIS_CACHE.set("lecture-#{lecture.id}", cached_url, { ex: (10 * 60) })
      # expiry_time.
    end

    render json: { url_hd: cached_url, url_sd: cached_url }
  end

  def get_yt_url
    lecture = VideoLecture.find_by(id: params[:video_id])
    render json: { url_hd: nil, url_sd: nil } and return if lecture.blank?

    cached_url = REDIS_CACHE.get("lecture-#{lecture.id}")
    if cached_url.blank?
      cached_url = yt_url(lecture)
      REDIS_CACHE.set("lecture-#{lecture.id}", cached_url, { ex: (10 * 60) })
      # expiry_time.
    end

    render json: { url_hd: cached_url, url_sd: cached_url }
  end

  def set_yt_url
    lecture = VideoLecture.find_by(id: params[:video_id])
    render json: {} and return if lecture.blank?

    REDIS_CACHE.set("lecture-#{lecture.id}-url_sd", params[:urls][:url_sd], { ex: (10 * 60) })
    REDIS_CACHE.set("lecture-#{lecture.id}-url_hd", params[:urls][:url_hd], { ex: (10 * 60) })

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
      'jpuerdtg-dest:397agm6x94s1@45.72.30.159:80',
      'jpuerdtg-dest:397agm6x94s1@209.127.191.180:80',
      'jpuerdtg-dest:397agm6x94s1@45.130.255.147:80',
      'jpuerdtg-dest:397agm6x94s1@193.8.127.117:80',
      'jpuerdtg-dest:397agm6x94s1@193.8.215.243:80',
      'jpuerdtg-dest:397agm6x94s1@45.130.125.157:80',
      'jpuerdtg-dest:397agm6x94s1@45.130.255.140:80',
      'jpuerdtg-dest:397agm6x94s1@45.130.255.198:80',
      'jpuerdtg-dest:397agm6x94s1@185.164.56.221:80',
      'jpuerdtg-dest:397agm6x94s1@45.136.231.226:80',
    ]
  end

  def yt_url(lecture)
    str_url = `youtube-dl --get-url --format 18/22 '#{lecture.url}'`
    return str_url if str_url.present?

    url_from_proxy = `youtube-dl --get-url --format 18/22 '#{lecture.url}' --proxy #{proxy_list[Random.rand(9)]}`
    url_from_proxy.squish
  end

  def lectures_json(lectures)
    lectures_data = {}
    lectures.each do |lect|
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
