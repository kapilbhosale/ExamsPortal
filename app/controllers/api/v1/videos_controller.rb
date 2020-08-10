# frozen_string_literal: true

class Api::V1::VideosController < Api::V1::ApiController

  def index
    lectures = VideoLecture.includes(:batches, :subjects)
      .where(batches: {id: current_student.batches})
      .where(enabled: true)
      .order(id: :desc)

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

    render json: lectures_data, status: :ok
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

  def categories
    video_lectures = VideoLecture
      .includes(:genre, :subject, :batches)
      .where(org_id: current_org.id)
      .where(batches: { id: current_student.batches.ids })
      .where(enabled: true)
    categories_data = {}
    video_lectures.all.each do |vl|
      subject_id = vl.subject&.name
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
      'lavtrqwu-1:g23565b4790l@p.webshare.io:80',
      'lavtrqwu-2:g23565b4790l@p.webshare.io:80',
      'lavtrqwu-3:g23565b4790l@p.webshare.io:80',
      'lavtrqwu-4:g23565b4790l@p.webshare.io:80',
      'lavtrqwu-5:g23565b4790l@p.webshare.io:80',
      'lavtrqwu-6:g23565b4790l@p.webshare.io:80',
      'lavtrqwu-7:g23565b4790l@p.webshare.io:80',
      'lavtrqwu-8:g23565b4790l@p.webshare.io:80',
      'lavtrqwu-9:g23565b4790l@p.webshare.io:80',
      'lavtrqwu-10:g23565b4790l@p.webshare.io:80',
      'pwhlocmq-1:ebg4tkw62oup@p.webshare.io:80',
      'pwhlocmq-2:ebg4tkw62oup@p.webshare.io:80',
      'pwhlocmq-3:ebg4tkw62oup@p.webshare.io:80',
      'pwhlocmq-4:ebg4tkw62oup@p.webshare.io:80',
      'pwhlocmq-5:ebg4tkw62oup@p.webshare.io:80',
      'pwhlocmq-6:ebg4tkw62oup@p.webshare.io:80',
      'pwhlocmq-7:ebg4tkw62oup@p.webshare.io:80',
      'pwhlocmq-8:ebg4tkw62oup@p.webshare.io:80',
      'pwhlocmq-9:ebg4tkw62oup@p.webshare.io:80',
      'pwhlocmq-10:ebg4tkw62oup@p.webshare.io:80',
      'iylfweeq-1:u2c67lfqt9r1@p.webshare.io:80',
      'iylfweeq-2:u2c67lfqt9r1@p.webshare.io:80',
      'iylfweeq-3:u2c67lfqt9r1@p.webshare.io:80',
      'iylfweeq-4:u2c67lfqt9r1@p.webshare.io:80',
      'iylfweeq-5:u2c67lfqt9r1@p.webshare.io:80',
      'iylfweeq-6:u2c67lfqt9r1@p.webshare.io:80',
      'iylfweeq-7:u2c67lfqt9r1@p.webshare.io:80',
      'iylfweeq-8:u2c67lfqt9r1@p.webshare.io:80',
      'iylfweeq-9:u2c67lfqt9r1@p.webshare.io:80',
      'iylfweeq-10:u2c67lfqt9r@p.webshare.io:80',
    ]
  end

  def yt_url(lecture)
    str_url = `youtube-dl --get-url --format 18/22 '#{lecture.url}'`
    return str_url if str_url.present?

    `youtube-dl --get-url --format 18/22 '#{lecture.url}' --proxy #{proxy_list[Random.rand(29)]}`
  end

  def lectures_json(lectures)
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
    if current_org&.subdomain == 'yashwant-clg'
      {
        'Physics' => lectures_data['phy'],
        'Chemistry' => lectures_data['chem'],
        'Biology' => lectures_data['bio'],
        'Maths' => lectures_data['maths'],
        'English' => lectures_data['english'],
        'Econonics' => lectures_data['econonics'],
        'BK & A/C' => lectures_data['bk & a/c'],
        'S.P.' => lectures_data['s.p'],
        'O.C.M' => lectures_data['o.c.m.'],
        'MATHS(com)' => lectures_data['maths(com)']
      }
    else
      {
        'Chemistry' => lectures_data['chem'],
        'Physics' => lectures_data['phy'],
        'Biology' => lectures_data['bio'],
        'Maths' => lectures_data['maths']
      }
    end
  end
end
