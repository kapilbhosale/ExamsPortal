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
      lect_data['added_ago'] = helpers.time_ago_in_words(lect.publish_at || lect.created_at)
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
      if request.subdomain == 'exams'
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

    if student_video_folders.blank? && cached_data.present?
      render json: JSON.parse(cached_data), status: :ok and return
    end

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
      lect_data = lect.attributes.slice("id" ,"title", "url", "video_id", "description", "by", "tag", "subject_id", "video_type")
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

  def proxy_list
    [
      'mvjxvmzc-dest:l15yq4x69d27@193.8.231.228:9234',
      'mvjxvmzc-dest:l15yq4x69d27@198.154.92.15:9085',
      'mvjxvmzc-dest:l15yq4x69d27@144.168.151.68:6112',
      'mvjxvmzc-dest:l15yq4x69d27@45.140.14.97:8113',
      'mvjxvmzc-dest:l15yq4x69d27@193.23.245.218:8789',
      'mvjxvmzc-dest:l15yq4x69d27@193.5.65.172:8678',
      'mvjxvmzc-dest:l15yq4x69d27@45.154.84.146:8197',
      'mvjxvmzc-dest:l15yq4x69d27@185.164.57.199:7702',
      'mvjxvmzc-dest:l15yq4x69d27@23.229.119.73:7100',
      'mvjxvmzc-dest:l15yq4x69d27@45.141.176.155:8720',
      'mvjxvmzc-dest:l15yq4x69d27@192.241.94.23:7578',
      'mvjxvmzc-dest:l15yq4x69d27@45.136.231.197:7253',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.80.131:9151',
      'mvjxvmzc-dest:l15yq4x69d27@193.5.251.231:7738',
      'mvjxvmzc-dest:l15yq4x69d27@45.131.212.193:6242',
      'mvjxvmzc-dest:l15yq4x69d27@104.227.101.209:6270',
      'mvjxvmzc-dest:l15yq4x69d27@185.250.39.249:8768',
      'mvjxvmzc-dest:l15yq4x69d27@193.27.19.14:7100',
      'mvjxvmzc-dest:l15yq4x69d27@45.158.185.214:8726',
      'mvjxvmzc-dest:l15yq4x69d27@107.152.197.209:8231',
      'mvjxvmzc-dest:l15yq4x69d27@23.229.122.244:8272',
      'mvjxvmzc-dest:l15yq4x69d27@23.229.125.101:9130',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.125.191:6208',
      'mvjxvmzc-dest:l15yq4x69d27@138.128.114.152:7718',
      'mvjxvmzc-dest:l15yq4x69d27@104.227.28.116:9174',
      'mvjxvmzc-dest:l15yq4x69d27@45.152.202.51:9056',
      'mvjxvmzc-dest:l15yq4x69d27@23.236.168.76:8624',
      'mvjxvmzc-dest:l15yq4x69d27@45.57.225.223:9305',
      'mvjxvmzc-dest:l15yq4x69d27@45.57.255.243:7282',
      'mvjxvmzc-dest:l15yq4x69d27@104.227.173.20:8083',
      'mvjxvmzc-dest:l15yq4x69d27@45.154.84.87:8138',
      'mvjxvmzc-dest:l15yq4x69d27@45.147.28.210:9268',
      'mvjxvmzc-dest:l15yq4x69d27@23.229.107.118:7643',
      'mvjxvmzc-dest:l15yq4x69d27@23.254.90.7:8047',
      'mvjxvmzc-dest:l15yq4x69d27@23.229.125.81:9110',
      'mvjxvmzc-dest:l15yq4x69d27@104.144.72.142:6174',
      'mvjxvmzc-dest:l15yq4x69d27@198.154.89.158:6249',
      'mvjxvmzc-dest:l15yq4x69d27@23.254.90.193:8233',
      'mvjxvmzc-dest:l15yq4x69d27@45.158.187.211:7220',
      'mvjxvmzc-dest:l15yq4x69d27@138.128.114.121:7687',
      'mvjxvmzc-dest:l15yq4x69d27@69.58.12.116:8121',
      'mvjxvmzc-dest:l15yq4x69d27@45.57.237.219:8294',
      'mvjxvmzc-dest:l15yq4x69d27@193.27.21.43:8130',
      'mvjxvmzc-dest:l15yq4x69d27@192.156.217.99:7173',
      'mvjxvmzc-dest:l15yq4x69d27@45.87.249.134:7712',
      'mvjxvmzc-dest:l15yq4x69d27@45.128.245.135:9146',
      'mvjxvmzc-dest:l15yq4x69d27@192.153.171.56:6129',
      'mvjxvmzc-dest:l15yq4x69d27@185.30.232.112:7057',
      'mvjxvmzc-dest:l15yq4x69d27@193.23.245.127:8698',
      'mvjxvmzc-dest:l15yq4x69d27@45.151.104.60:9112',
      'mvjxvmzc-dest:l15yq4x69d27@45.94.47.176:8220',
      'mvjxvmzc-dest:l15yq4x69d27@45.146.128.140:8209',
      'mvjxvmzc-dest:l15yq4x69d27@45.146.128.74:8143',
      'mvjxvmzc-dest:l15yq4x69d27@192.166.153.69:8144',
      'mvjxvmzc-dest:l15yq4x69d27@45.154.56.190:7208',
      'mvjxvmzc-dest:l15yq4x69d27@45.128.76.116:6117',
      'mvjxvmzc-dest:l15yq4x69d27@45.8.134.180:7196',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.255.148:7170',
      'mvjxvmzc-dest:l15yq4x69d27@45.134.187.17:7054',
      'mvjxvmzc-dest:l15yq4x69d27@45.152.202.63:9068',
      'mvjxvmzc-dest:l15yq4x69d27@195.158.192.186:8763',
      'mvjxvmzc-dest:l15yq4x69d27@45.94.47.222:8266',
      'mvjxvmzc-dest:l15yq4x69d27@45.154.56.174:7192',
      'mvjxvmzc-dest:l15yq4x69d27@185.164.57.169:7672',
      'mvjxvmzc-dest:l15yq4x69d27@45.154.58.10:7523',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.255.23:7045',
      'mvjxvmzc-dest:l15yq4x69d27@185.126.66.131:7647',
      'mvjxvmzc-dest:l15yq4x69d27@193.27.19.212:7298',
      'mvjxvmzc-dest:l15yq4x69d27@45.154.84.195:8246',
      'mvjxvmzc-dest:l15yq4x69d27@45.136.173.207:7797',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.195.223:6238',
      'mvjxvmzc-dest:l15yq4x69d27@45.152.200.82:9628',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.56.38:9102',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.56.139:9203',
      'mvjxvmzc-dest:l15yq4x69d27@45.154.84.222:8273',
      'mvjxvmzc-dest:l15yq4x69d27@45.152.200.130:9676',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.80.79:9099',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.255.220:7242',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.127.235:9317',
      'mvjxvmzc-dest:l15yq4x69d27@45.9.122.112:8193',
      'mvjxvmzc-dest:l15yq4x69d27@45.94.47.109:8153',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.80.229:9249',
      'mvjxvmzc-dest:l15yq4x69d27@193.27.21.218:8305',
      'mvjxvmzc-dest:l15yq4x69d27@5.182.32.150:7664',
      'mvjxvmzc-dest:l15yq4x69d27@45.152.202.36:9041',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.231.71:9077',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.43.21:7575',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.40.115:8668',
      'mvjxvmzc-dest:l15yq4x69d27@193.27.19.56:7142',
      'mvjxvmzc-dest:l15yq4x69d27@45.128.24.81:7083',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.195.179:6194',
      'mvjxvmzc-dest:l15yq4x69d27@45.136.231.141:7197',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.43.125:7679',
      'mvjxvmzc-dest:l15yq4x69d27@45.155.71.103:8692',
      'mvjxvmzc-dest:l15yq4x69d27@45.134.187.254:7291',
      'mvjxvmzc-dest:l15yq4x69d27@171.22.145.253:8766',
      'mvjxvmzc-dest:l15yq4x69d27@45.155.70.1:8011',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.94.92:9137',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.195.237:6252',
      'mvjxvmzc-dest:l15yq4x69d27@45.155.71.37:8626',
      'mvjxvmzc-dest:l15yq4x69d27@45.136.231.171:7227',
      'mvjxvmzc-dest:l15yq4x69d27@45.136.231.168:7224',
      'mvjxvmzc-dest:l15yq4x69d27@193.27.23.117:9205',
      'mvjxvmzc-dest:l15yq4x69d27@45.87.249.228:7806',
      'mvjxvmzc-dest:l15yq4x69d27@45.134.187.124:7161',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.127.251:9333',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.43.30:7584',
      'mvjxvmzc-dest:l15yq4x69d27@45.136.228.236:6291',
      'mvjxvmzc-dest:l15yq4x69d27@45.152.202.179:9184',
      'mvjxvmzc-dest:l15yq4x69d27@45.140.14.92:8108',
      'mvjxvmzc-dest:l15yq4x69d27@45.128.76.130:6131',
      'mvjxvmzc-dest:l15yq4x69d27@45.128.24.80:7082',
      'mvjxvmzc-dest:l15yq4x69d27@45.155.70.139:8149',
      'mvjxvmzc-dest:l15yq4x69d27@193.39.245.31:6039',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.60.144:9671',
      'mvjxvmzc-dest:l15yq4x69d27@5.182.32.194:7708',
      'mvjxvmzc-dest:l15yq4x69d27@45.136.228.121:6176',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.94.142:9187',
      'mvjxvmzc-dest:l15yq4x69d27@45.8.134.202:7218',
      'mvjxvmzc-dest:l15yq4x69d27@45.9.122.119:8200',
      'mvjxvmzc-dest:l15yq4x69d27@45.145.56.194:7760',
      'mvjxvmzc-dest:l15yq4x69d27@45.136.231.163:7219',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.127.207:9289',
      'mvjxvmzc-dest:l15yq4x69d27@185.164.57.140:7643',
      'mvjxvmzc-dest:l15yq4x69d27@45.136.228.254:6309',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.56.96:9160',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.84.97:7147',
      'mvjxvmzc-dest:l15yq4x69d27@45.9.122.118:8199',
      'mvjxvmzc-dest:l15yq4x69d27@45.145.56.222:7788',
      'mvjxvmzc-dest:l15yq4x69d27@45.155.70.224:8234',
      'mvjxvmzc-dest:l15yq4x69d27@5.182.32.249:7763',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.138.124:9163',
      'mvjxvmzc-dest:l15yq4x69d27@45.141.176.164:8729',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.43.164:7718',
      'mvjxvmzc-dest:l15yq4x69d27@45.134.187.111:7148',
      'mvjxvmzc-dest:l15yq4x69d27@45.136.228.77:6132',
      'mvjxvmzc-dest:l15yq4x69d27@193.27.21.132:8219',
      'mvjxvmzc-dest:l15yq4x69d27@185.164.57.214:7717',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.94.120:9165',
      'mvjxvmzc-dest:l15yq4x69d27@45.136.228.9:6064',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.56.238:9302',
      'mvjxvmzc-dest:l15yq4x69d27@45.136.228.196:6251',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.84.187:7237',
      'mvjxvmzc-dest:l15yq4x69d27@45.136.231.87:7143',
      'mvjxvmzc-dest:l15yq4x69d27@5.182.32.220:7734',
      'mvjxvmzc-dest:l15yq4x69d27@45.134.187.93:7130',
      'mvjxvmzc-dest:l15yq4x69d27@45.128.76.78:6079',
      'mvjxvmzc-dest:l15yq4x69d27@45.155.70.103:8113',
      'mvjxvmzc-dest:l15yq4x69d27@193.27.21.159:8246',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.40.76:8629',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.195.209:6224',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.84.167:7217',
      'mvjxvmzc-dest:l15yq4x69d27@85.209.129.79:8619',
      'mvjxvmzc-dest:l15yq4x69d27@45.141.176.237:8802',
      'mvjxvmzc-dest:l15yq4x69d27@185.164.57.47:7550',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.127.230:9312',
      'mvjxvmzc-dest:l15yq4x69d27@45.136.228.206:6261',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.40.10:8563',
      'mvjxvmzc-dest:l15yq4x69d27@45.9.122.133:8214',
      'mvjxvmzc-dest:l15yq4x69d27@45.136.231.186:7242',
      'mvjxvmzc-dest:l15yq4x69d27@45.8.134.2:7018',
      'mvjxvmzc-dest:l15yq4x69d27@45.154.58.67:7580',
      'mvjxvmzc-dest:l15yq4x69d27@45.136.231.212:7268',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.43.77:7631',
      'mvjxvmzc-dest:l15yq4x69d27@193.27.21.111:8198',
      'mvjxvmzc-dest:l15yq4x69d27@185.164.56.172:8677',
      'mvjxvmzc-dest:l15yq4x69d27@182.54.239.10:8027',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.60.220:9747',
      'mvjxvmzc-dest:l15yq4x69d27@45.87.249.80:7658',
      'mvjxvmzc-dest:l15yq4x69d27@45.8.134.198:7214',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.60.205:9732',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.43.102:7656',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.43.189:7743',
      'mvjxvmzc-dest:l15yq4x69d27@185.250.39.57:8576',
      'mvjxvmzc-dest:l15yq4x69d27@45.141.176.53:8618',
      'mvjxvmzc-dest:l15yq4x69d27@45.8.134.137:7153',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.195.242:6257',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.195.212:6227',
      'mvjxvmzc-dest:l15yq4x69d27@45.155.71.243:8832',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.80.114:9134',
      'mvjxvmzc-dest:l15yq4x69d27@45.136.231.9:7065',
      'mvjxvmzc-dest:l15yq4x69d27@45.141.176.25:8590',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.40.116:8669',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.195.106:6121',
      'mvjxvmzc-dest:l15yq4x69d27@185.164.57.242:7745',
      'mvjxvmzc-dest:l15yq4x69d27@45.145.56.65:7631',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.195.87:6102',
      'mvjxvmzc-dest:l15yq4x69d27@45.134.187.233:7270',
      'mvjxvmzc-dest:l15yq4x69d27@45.155.70.82:8092',
      'mvjxvmzc-dest:l15yq4x69d27@45.152.202.70:9075',
      'mvjxvmzc-dest:l15yq4x69d27@45.136.231.44:7100',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.43.75:7629',
      'mvjxvmzc-dest:l15yq4x69d27@185.250.39.190:8709',
      'mvjxvmzc-dest:l15yq4x69d27@185.250.39.129:8648',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.43.130:7684',
      'mvjxvmzc-dest:l15yq4x69d27@45.136.231.185:7241',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.138.175:9214',
      'mvjxvmzc-dest:l15yq4x69d27@185.164.56.3:8508',
      'mvjxvmzc-dest:l15yq4x69d27@182.54.239.167:8184',
      'mvjxvmzc-dest:l15yq4x69d27@193.39.245.37:6045',
      'mvjxvmzc-dest:l15yq4x69d27@45.86.15.93:8640',
      'mvjxvmzc-dest:l15yq4x69d27@45.9.122.166:8247',
      'mvjxvmzc-dest:l15yq4x69d27@45.136.231.33:7089',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.40.217:8770',
      'mvjxvmzc-dest:l15yq4x69d27@45.136.228.170:6225',
      'mvjxvmzc-dest:l15yq4x69d27@45.145.56.83:7649',
      'mvjxvmzc-dest:l15yq4x69d27@45.9.122.242:8323',
      'mvjxvmzc-dest:l15yq4x69d27@45.136.228.127:6182',
      'mvjxvmzc-dest:l15yq4x69d27@182.54.239.54:8071',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.84.26:7076',
      'mvjxvmzc-dest:l15yq4x69d27@45.9.122.105:8186',
      'mvjxvmzc-dest:l15yq4x69d27@182.54.239.78:8095',
      'mvjxvmzc-dest:l15yq4x69d27@45.155.70.143:8153',
      'mvjxvmzc-dest:l15yq4x69d27@45.9.122.21:8102',
      'mvjxvmzc-dest:l15yq4x69d27@45.145.56.106:7672',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.43.36:7590',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.43.2:7556',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.40.74:8627',
      'mvjxvmzc-dest:l15yq4x69d27@45.140.14.60:8076',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.40.202:8755',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.43.226:7780',
      'mvjxvmzc-dest:l15yq4x69d27@45.9.122.136:8217',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.40.86:8639',
      'mvjxvmzc-dest:l15yq4x69d27@182.54.239.185:8202',
      'mvjxvmzc-dest:l15yq4x69d27@185.164.56.50:8555',
      'mvjxvmzc-dest:l15yq4x69d27@85.209.129.192:8732',
      'mvjxvmzc-dest:l15yq4x69d27@185.126.65.26:7536',
      'mvjxvmzc-dest:l15yq4x69d27@193.39.245.100:6108',
      'mvjxvmzc-dest:l15yq4x69d27@45.9.122.170:8251',
      'mvjxvmzc-dest:l15yq4x69d27@45.152.202.128:9133',
      'mvjxvmzc-dest:l15yq4x69d27@45.94.47.216:8260',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.40.83:8636',
      'mvjxvmzc-dest:l15yq4x69d27@45.142.28.19:8030',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.43.111:7665',
      'mvjxvmzc-dest:l15yq4x69d27@45.94.47.57:8101',
      'mvjxvmzc-dest:l15yq4x69d27@45.142.28.250:8261',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.43.99:7653',
      'mvjxvmzc-dest:l15yq4x69d27@45.94.47.53:8097',
      'mvjxvmzc-dest:l15yq4x69d27@45.142.28.69:8080',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.43.206:7760',
      'mvjxvmzc-dest:l15yq4x69d27@45.145.56.212:7778',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.60.224:9751',
      'mvjxvmzc-dest:l15yq4x69d27@45.87.249.88:7666',
      'mvjxvmzc-dest:l15yq4x69d27@45.152.202.129:9134',
      'mvjxvmzc-dest:l15yq4x69d27@45.87.248.196:7719',
      'mvjxvmzc-dest:l15yq4x69d27@45.140.14.6:8022',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.43.83:7637',
      'mvjxvmzc-dest:l15yq4x69d27@45.87.249.157:7735',
      'mvjxvmzc-dest:l15yq4x69d27@45.87.248.222:7745',
      'mvjxvmzc-dest:l15yq4x69d27@45.87.249.208:7786',
      'mvjxvmzc-dest:l15yq4x69d27@45.152.202.134:9139',
      'mvjxvmzc-dest:l15yq4x69d27@45.155.71.225:8814',
      'mvjxvmzc-dest:l15yq4x69d27@182.54.239.27:8044',
      'mvjxvmzc-dest:l15yq4x69d27@45.87.249.165:7743',
      'mvjxvmzc-dest:l15yq4x69d27@45.87.249.173:7751',
      'mvjxvmzc-dest:l15yq4x69d27@45.86.15.98:8645',
      'mvjxvmzc-dest:l15yq4x69d27@182.54.239.98:8115',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.255.21:7043',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.60.92:9619',
      'mvjxvmzc-dest:l15yq4x69d27@45.94.47.102:8146',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.138.54:9093',
      'mvjxvmzc-dest:l15yq4x69d27@185.164.56.19:8524',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.80.66:9086',
      'mvjxvmzc-dest:l15yq4x69d27@45.155.71.5:8594',
      'mvjxvmzc-dest:l15yq4x69d27@45.155.70.216:8226',
      'mvjxvmzc-dest:l15yq4x69d27@182.54.239.61:8078',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.60.174:9701',
      'mvjxvmzc-dest:l15yq4x69d27@185.164.56.79:8584',
      'mvjxvmzc-dest:l15yq4x69d27@45.154.58.206:7719',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.60.24:9551',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.60.77:9604',
      'mvjxvmzc-dest:l15yq4x69d27@45.87.249.85:7663',
      'mvjxvmzc-dest:l15yq4x69d27@45.87.248.131:7654',
      'mvjxvmzc-dest:l15yq4x69d27@45.155.70.48:8058',
      'mvjxvmzc-dest:l15yq4x69d27@45.154.58.217:7730',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.60.50:9577',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.60.98:9625',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.60.84:9611',
      'mvjxvmzc-dest:l15yq4x69d27@182.54.239.159:8176',
      'mvjxvmzc-dest:l15yq4x69d27@182.54.239.151:8168',
      'mvjxvmzc-dest:l15yq4x69d27@182.54.239.183:8200',
      'mvjxvmzc-dest:l15yq4x69d27@45.87.248.30:7553',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.60.124:9651',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.138.63:9102',
      'mvjxvmzc-dest:l15yq4x69d27@182.54.239.83:8100',
      'mvjxvmzc-dest:l15yq4x69d27@182.54.239.64:8081',
      'mvjxvmzc-dest:l15yq4x69d27@45.86.15.137:8684',
      'mvjxvmzc-dest:l15yq4x69d27@45.94.47.113:8157',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.80.113:9133',
      'mvjxvmzc-dest:l15yq4x69d27@45.86.15.20:8567',
      'mvjxvmzc-dest:l15yq4x69d27@45.86.15.174:8721',
      'mvjxvmzc-dest:l15yq4x69d27@182.54.239.230:8247',
      'mvjxvmzc-dest:l15yq4x69d27@45.155.70.69:8079',
      'mvjxvmzc-dest:l15yq4x69d27@45.154.58.148:7661',
      'mvjxvmzc-dest:l15yq4x69d27@45.86.15.218:8765',
      'mvjxvmzc-dest:l15yq4x69d27@45.154.58.79:7592',
      'mvjxvmzc-dest:l15yq4x69d27@45.142.28.190:8201',
      'mvjxvmzc-dest:l15yq4x69d27@45.154.58.115:7628',
      'mvjxvmzc-dest:l15yq4x69d27@45.87.249.78:7656',
      'mvjxvmzc-dest:l15yq4x69d27@182.54.239.63:8080',
      'mvjxvmzc-dest:l15yq4x69d27@45.86.15.12:8559',
      'mvjxvmzc-dest:l15yq4x69d27@45.94.47.154:8198',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.84.24:7074',
      'mvjxvmzc-dest:l15yq4x69d27@45.155.70.19:8029',
      'mvjxvmzc-dest:l15yq4x69d27@185.164.56.250:8755',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.84.46:7096',
      'mvjxvmzc-dest:l15yq4x69d27@182.54.239.92:8109',
      'mvjxvmzc-dest:l15yq4x69d27@45.152.202.64:9069',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.84.122:7172',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.60.60:9587',
      'mvjxvmzc-dest:l15yq4x69d27@45.145.56.69:7635',
      'mvjxvmzc-dest:l15yq4x69d27@185.126.65.9:7519',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.80.42:9062',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.80.8:9028',
      'mvjxvmzc-dest:l15yq4x69d27@45.145.56.122:7688',
      'mvjxvmzc-dest:l15yq4x69d27@45.94.47.156:8200',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.255.33:7055',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.60.193:9720',
      'mvjxvmzc-dest:l15yq4x69d27@45.94.47.206:8250',
      'mvjxvmzc-dest:l15yq4x69d27@45.87.248.43:7566',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.60.191:9718',
      'mvjxvmzc-dest:l15yq4x69d27@45.145.56.133:7699',
      'mvjxvmzc-dest:l15yq4x69d27@45.87.249.233:7811',
      'mvjxvmzc-dest:l15yq4x69d27@45.142.28.234:8245',
      'mvjxvmzc-dest:l15yq4x69d27@45.142.28.96:8107',
      'mvjxvmzc-dest:l15yq4x69d27@182.54.239.140:8157',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.255.169:7191',
      'mvjxvmzc-dest:l15yq4x69d27@182.54.239.122:8139',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.138.252:9291',
      'mvjxvmzc-dest:l15yq4x69d27@182.54.239.208:8225',
      'mvjxvmzc-dest:l15yq4x69d27@182.54.239.249:8266',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.80.253:9273',
      'mvjxvmzc-dest:l15yq4x69d27@45.142.28.253:8264',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.255.42:7064',
      'mvjxvmzc-dest:l15yq4x69d27@45.155.70.227:8237',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.60.79:9606',
      'mvjxvmzc-dest:l15yq4x69d27@45.152.202.48:9053',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.80.221:9241',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.60.67:9594',
      'mvjxvmzc-dest:l15yq4x69d27@45.142.28.12:8023',
      'mvjxvmzc-dest:l15yq4x69d27@45.152.202.91:9096',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.60.155:9682',
      'mvjxvmzc-dest:l15yq4x69d27@45.155.71.36:8625',
      'mvjxvmzc-dest:l15yq4x69d27@45.142.28.230:8241',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.80.87:9107',
      'mvjxvmzc-dest:l15yq4x69d27@182.54.239.165:8182',
      'mvjxvmzc-dest:l15yq4x69d27@182.54.239.175:8192',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.80.72:9092',
      'mvjxvmzc-dest:l15yq4x69d27@45.87.249.112:7690',
      'mvjxvmzc-dest:l15yq4x69d27@45.86.15.160:8707',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.255.10:7032',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.84.155:7205',
      'mvjxvmzc-dest:l15yq4x69d27@182.54.239.19:8036',
      'mvjxvmzc-dest:l15yq4x69d27@45.154.58.96:7609',
      'mvjxvmzc-dest:l15yq4x69d27@45.152.202.144:9149',
      'mvjxvmzc-dest:l15yq4x69d27@45.152.202.176:9181',
      'mvjxvmzc-dest:l15yq4x69d27@45.142.28.238:8249',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.255.2:7024',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.255.1:7023',
      'mvjxvmzc-dest:l15yq4x69d27@45.142.28.198:8209',
      'mvjxvmzc-dest:l15yq4x69d27@45.142.28.175:8186',
      'mvjxvmzc-dest:l15yq4x69d27@185.126.65.1:7511',
      'mvjxvmzc-dest:l15yq4x69d27@185.126.65.2:7512',
      'mvjxvmzc-dest:l15yq4x69d27@185.126.65.3:7513',
      'mvjxvmzc-dest:l15yq4x69d27@185.126.65.5:7515',
      'mvjxvmzc-dest:l15yq4x69d27@185.126.65.6:7516',
      'mvjxvmzc-dest:l15yq4x69d27@185.126.65.11:7521',
      'mvjxvmzc-dest:l15yq4x69d27@185.126.65.13:7523',
      'mvjxvmzc-dest:l15yq4x69d27@185.126.65.15:7525',
      'mvjxvmzc-dest:l15yq4x69d27@185.126.65.16:7526',
      'mvjxvmzc-dest:l15yq4x69d27@185.126.65.18:7528',
      'mvjxvmzc-dest:l15yq4x69d27@185.126.65.19:7529',
      'mvjxvmzc-dest:l15yq4x69d27@185.126.65.24:7534',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.60.242:9769',
      'mvjxvmzc-dest:l15yq4x69d27@185.126.65.30:7540',
      'mvjxvmzc-dest:l15yq4x69d27@45.142.28.151:8162',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.60.189:9716',
      'mvjxvmzc-dest:l15yq4x69d27@45.142.28.147:8158',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.60.178:9705',
      'mvjxvmzc-dest:l15yq4x69d27@45.142.28.119:8130',
      'mvjxvmzc-dest:l15yq4x69d27@45.142.28.118:8129',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.60.157:9684',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.231.178:9184',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.255.232:7254',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.255.213:7235',
      'mvjxvmzc-dest:l15yq4x69d27@45.86.15.99:8646',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.255.201:7223',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.255.200:7222',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.255.253:7275',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.255.254:7276',
      'mvjxvmzc-dest:l15yq4x69d27@45.86.15.253:8800',
      'mvjxvmzc-dest:l15yq4x69d27@45.86.15.115:8662',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.255.181:7203',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.255.154:7176',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.255.152:7174',
      'mvjxvmzc-dest:l15yq4x69d27@45.86.15.236:8783',
      'mvjxvmzc-dest:l15yq4x69d27@45.86.15.234:8781',
      'mvjxvmzc-dest:l15yq4x69d27@45.87.248.7:7530',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.255.143:7165',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.255.141:7163',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.255.117:7139',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.255.109:7131',
      'mvjxvmzc-dest:l15yq4x69d27@45.86.15.163:8710',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.255.86:7108',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.255.85:7107',
      'mvjxvmzc-dest:l15yq4x69d27@45.86.15.179:8726',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.255.82:7104',
      'mvjxvmzc-dest:l15yq4x69d27@45.86.15.85:8632',
      'mvjxvmzc-dest:l15yq4x69d27@45.86.15.83:8630',
      'mvjxvmzc-dest:l15yq4x69d27@45.86.15.82:8629',
      'mvjxvmzc-dest:l15yq4x69d27@85.209.129.49:8589',
      'mvjxvmzc-dest:l15yq4x69d27@85.209.129.81:8621',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.255.34:7056',
      'mvjxvmzc-dest:l15yq4x69d27@85.209.129.227:8767',
      'mvjxvmzc-dest:l15yq4x69d27@85.209.130.8:7549',
      'mvjxvmzc-dest:l15yq4x69d27@85.209.130.41:7582',
      'mvjxvmzc-dest:l15yq4x69d27@85.209.130.82:7623',
      'mvjxvmzc-dest:l15yq4x69d27@85.209.130.220:7761',
      'mvjxvmzc-dest:l15yq4x69d27@45.86.15.64:8611',
      'mvjxvmzc-dest:l15yq4x69d27@45.86.15.51:8598',
      'mvjxvmzc-dest:l15yq4x69d27@45.86.15.45:8592',
      'mvjxvmzc-dest:l15yq4x69d27@45.86.15.44:8591',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.80.5:9025',
      'mvjxvmzc-dest:l15yq4x69d27@45.86.15.10:8557',
      'mvjxvmzc-dest:l15yq4x69d27@45.86.15.1:8548',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.80.31:9051',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.255.16:7038',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.80.46:9066',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.138.180:9219',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.138.181:9220',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.138.203:9242',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.138.210:9249',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.138.215:9254',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.138.232:9271',
      'mvjxvmzc-dest:l15yq4x69d27@45.92.247.150:6658',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.231.73:9079',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.231.102:9108',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.231.107:9113',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.231.136:9142',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.231.212:9218',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.231.233:9239',
      'mvjxvmzc-dest:l15yq4x69d27@45.92.247.71:6579',
      'mvjxvmzc-dest:l15yq4x69d27@45.92.247.69:6577',
      'mvjxvmzc-dest:l15yq4x69d27@45.92.247.8:6516',
      'mvjxvmzc-dest:l15yq4x69d27@45.87.249.209:7787',
      'mvjxvmzc-dest:l15yq4x69d27@45.86.15.189:8736',
      'mvjxvmzc-dest:l15yq4x69d27@45.86.15.212:8759',
      'mvjxvmzc-dest:l15yq4x69d27@45.87.248.168:7691',
      'mvjxvmzc-dest:l15yq4x69d27@45.87.249.90:7668',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.84.42:7092',
      'mvjxvmzc-dest:l15yq4x69d27@45.140.13.123:9136',
      'mvjxvmzc-dest:l15yq4x69d27@45.87.249.30:7608',
      'mvjxvmzc-dest:l15yq4x69d27@45.87.248.237:7760',
      'mvjxvmzc-dest:l15yq4x69d27@45.142.28.100:8111',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.60.122:9649',
      'mvjxvmzc-dest:l15yq4x69d27@45.142.28.94:8105',
      'mvjxvmzc-dest:l15yq4x69d27@45.142.28.89:8100',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.84.163:7213',
      'mvjxvmzc-dest:l15yq4x69d27@45.142.28.55:8066',
      'mvjxvmzc-dest:l15yq4x69d27@45.142.28.42:8053',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.60.20:9547',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.60.16:9543',
      'mvjxvmzc-dest:l15yq4x69d27@45.87.248.61:7584',
      'mvjxvmzc-dest:l15yq4x69d27@45.142.28.35:8046',
      'mvjxvmzc-dest:l15yq4x69d27@45.87.248.161:7684',
      'mvjxvmzc-dest:l15yq4x69d27@45.142.28.29:8040',
      'mvjxvmzc-dest:l15yq4x69d27@45.142.28.18:8029',
      'mvjxvmzc-dest:l15yq4x69d27@45.92.247.235:6743',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.138.4:9043',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.138.27:9066',
      'mvjxvmzc-dest:l15yq4x69d27@45.142.28.6:8017',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.80.192:9212',
      'mvjxvmzc-dest:l15yq4x69d27@45.92.247.209:6717',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.138.157:9196',
      'mvjxvmzc-dest:l15yq4x69d27@45.92.247.171:6679',
      'mvjxvmzc-dest:l15yq4x69d27@182.54.239.67:8084',
      'mvjxvmzc-dest:l15yq4x69d27@182.54.239.125:8142',
      'mvjxvmzc-dest:l15yq4x69d27@182.54.239.75:8092',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.231.249:9255',
      'mvjxvmzc-dest:l15yq4x69d27@185.126.65.4:7514',
      'mvjxvmzc-dest:l15yq4x69d27@185.126.65.17:7527',
      'mvjxvmzc-dest:l15yq4x69d27@85.209.130.44:7585',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.231.223:9229',
      'mvjxvmzc-dest:l15yq4x69d27@45.92.247.214:6722',
      'mvjxvmzc-dest:l15yq4x69d27@185.126.65.12:7522',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.231.137:9143',
      'mvjxvmzc-dest:l15yq4x69d27@85.209.130.69:7610',
      'mvjxvmzc-dest:l15yq4x69d27@45.92.247.78:6586',
      'mvjxvmzc-dest:l15yq4x69d27@185.126.65.8:7518',
      'mvjxvmzc-dest:l15yq4x69d27@85.209.129.190:8730',
      'mvjxvmzc-dest:l15yq4x69d27@85.209.129.175:8715',
      'mvjxvmzc-dest:l15yq4x69d27@185.126.65.14:7524',
      'mvjxvmzc-dest:l15yq4x69d27@185.126.65.29:7539',
      'mvjxvmzc-dest:l15yq4x69d27@185.126.65.27:7537',
      'mvjxvmzc-dest:l15yq4x69d27@185.126.65.0:7510',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.231.232:9238',
      'mvjxvmzc-dest:l15yq4x69d27@185.126.65.7:7517',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.231.66:9072',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.231.43:9049',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.231.16:9022'
    ]
  end

  def yt_json_info(lecture)
    video_data = `youtube-dl -j --format 18/22 '#{lecture.url}'`
    return JSON.parse(video_data) if video_data.present?

    video_data_from_proxy = `youtube-dl -j --format 18/22 '#{lecture.url}' --proxy #{proxy_list[Random.rand(499)]}`
    JSON.parse(video_data_from_proxy) if video_data_from_proxy.present?
  end

  def lectures_json(lectures)
    lectures_data = {}
    lectures.each do |lect|
      next if lect.publish_at.present? && lect.publish_at > Time.current

      lect_data = lect.attributes.slice("id" ,"title", "url", "video_id", "description", "by", "tag", "subject_id", "video_type")
      lect_data['thumbnail_url'] = lect.vimeo? ? lect.thumbnail : lect.uploaded_thumbnail.url
      lect_data['added_ago'] = helpers.time_ago_in_words(lect.publish_at || lect.created_at)
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
