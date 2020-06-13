# frozen_string_literal: true

class Api::V1::VideosController < Api::V1::ApiController

  def index
    lectures = VideoLecture.includes(:batches)
      .where(batches: {id: current_student.batches})
      .where(enabled: true)
      .order(id: :desc)

    lectures_data = {}
    lectures.each do |lect|
      lect_data = lect.attributes.slice("id" ,"title", "url", "video_id", "description", "by", "tag", "subject", "video_type")
      lect_data['thumbnail_url'] = lect.vimeo? ? lect.thumbnail : lect.uploaded_thumbnail.url
      lect_data['added_ago'] = helpers.time_ago_in_words(lect.created_at)
      if lect.vimeo?
        lect_data['play_url'] = "#{helpers.full_domain_path}/students/lectures/#{lect.video_id}"
      else
        lect_data['play_url'] = lect.url
      end
      lectures_data[lect.subject] ||= []
      lectures_data[lect.subject] << lect_data
    end
    json_data = {
      'Chemistry' => lectures_data['chem'],
      'Physics' => lectures_data['phy'],
      'Biology' => lectures_data['bio'],
      'Maths' => lectures_data['maths'],
    }
    render json: json_data, status: :ok
  end

  def get_yt_url
    lecture = VideoLecture.find_by(id: params[:video_id])
    render json: { url_hd: nil, url_sd: nil } and return if lecture.blank?

    cached_url = REDIS_CACHE.get("lecture-#{lecture.id}")
    if cached_url.blank?
      cached_url = yt_url(lecture)
      REDIS_CACHE.set("lecture-#{lecture.id}", cached_url, { ex: (10 * 60) })
    end

    render json: { url_hd: cached_url, url_sd: cached_url }
  end

  private

  def proxy_list
    [
      'uvxgivfo-1:1l0rqqeoj21y@p.webshare.io:80',
      'uvxgivfo-2:1l0rqqeoj21y@p.webshare.io:80',
      'uvxgivfo-3:1l0rqqeoj21y@p.webshare.io:80',
      'uvxgivfo-4:1l0rqqeoj21y@p.webshare.io:80',
      'uvxgivfo-5:1l0rqqeoj21y@p.webshare.io:80',
      'uvxgivfo-6:1l0rqqeoj21y@p.webshare.io:80',
      'uvxgivfo-7:1l0rqqeoj21y@p.webshare.io:80',
      'uvxgivfo-8:1l0rqqeoj21y@p.webshare.io:80',
      'uvxgivfo-9:1l0rqqeoj21y@p.webshare.io:80',
      'uvxgivfo-10:1l0rqqeoj21y@p.webshare.io:80',
    ]
  end

  def yt_url(lecture)
    `youtube-dl --get-url --format 18/22 '#{lecture.url}' --proxy #{proxy_list[Random.rand(9)]}`
  end
end
