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

    if current_org&.subdomain == 'yashwant-clg'
      json_data['English'] = lectures_data['english']
      json_data['Econonics'] = lectures_data['econonics']
      json_data['BK & A/C'] = lectures_data['bk & a/c']
      json_data['S.P.'] = lectures_data['s.p']
      json_data['O.C.M.'] = lectures_data['o.c.m.']
      json_data['MATHS(com)'] = lectures_data['maths(com)']
    end

    render json: json_data, status: :ok
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

  private

  def proxy_list
    [
      'qfzffyfo-1:gui1kqghpfhk@p.webshare.io:80',
      'qfzffyfo-2:gui1kqghpfhk@p.webshare.io:80',
      'qfzffyfo-3:gui1kqghpfhk@p.webshare.io:80',
      'qfzffyfo-4:gui1kqghpfhk@p.webshare.io:80',
      'qfzffyfo-5:gui1kqghpfhk@p.webshare.io:80',
      'qfzffyfo-6:gui1kqghpfhk@p.webshare.io:80',
      'qfzffyfo-7:gui1kqghpfhk@p.webshare.io:80',
      'qfzffyfo-8:gui1kqghpfhk@p.webshare.io:80',
      'qfzffyfo-9:gui1kqghpfhk@p.webshare.io:80',
      'qfzffyfo-10:gui1kqghpfhk@p.webshare.io:80',
      'qxvxhkkv-1:hsgwq3c9l72g@p.webshare.io:80',
      'qxvxhkkv-2:hsgwq3c9l72g@p.webshare.io:80',
      'qxvxhkkv-3:hsgwq3c9l72g@p.webshare.io:80',
      'qxvxhkkv-4:hsgwq3c9l72g@p.webshare.io:80',
      'qxvxhkkv-5:hsgwq3c9l72g@p.webshare.io:80',
      'qxvxhkkv-6:hsgwq3c9l72g@p.webshare.io:80',
      'qxvxhkkv-7:hsgwq3c9l72g@p.webshare.io:80',
      'qxvxhkkv-8:hsgwq3c9l72g@p.webshare.io:80',
      'qxvxhkkv-9:hsgwq3c9l72g@p.webshare.io:80',
      'qxvxhkkv-10:hsgwq3c9l72g@p.webshare.io:80',
      'xiunxxgd-1:kay3ohis2hz6@p.webshare.io:80',
      'xiunxxgd-2:kay3ohis2hz6@p.webshare.io:80',
      'xiunxxgd-3:kay3ohis2hz6@p.webshare.io:80',
      'xiunxxgd-4:kay3ohis2hz6@p.webshare.io:80',
      'xiunxxgd-5:kay3ohis2hz6@p.webshare.io:80',
      'xiunxxgd-6:kay3ohis2hz6@p.webshare.io:80',
      'xiunxxgd-7:kay3ohis2hz6@p.webshare.io:80',
      'xiunxxgd-8:kay3ohis2hz6@p.webshare.io:80',
      'xiunxxgd-9:kay3ohis2hz6@p.webshare.io:80',
      'xiunxxgd-10:kay3ohis2hz6@p.webshare.io:80'
    ]
  end

  def yt_url(lecture)
    str_url = `youtube-dl --get-url --format 18/22 '#{lecture.url}'`
    return str_url if str_url.present?

    `youtube-dl --get-url --format 18/22 '#{lecture.url}' --proxy #{proxy_list[Random.rand(29)]}`
  end
end

