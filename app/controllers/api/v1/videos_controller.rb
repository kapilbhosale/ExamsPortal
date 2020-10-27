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
      'mvjxvmzc-dest:l15yq4x69d27@23.229.122.244:80',
      'mvjxvmzc-dest:l15yq4x69d27@23.229.125.101:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.125.191:80',
      'mvjxvmzc-dest:l15yq4x69d27@138.128.114.152:80',
      'mvjxvmzc-dest:l15yq4x69d27@104.227.28.116:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.152.202.51:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.57.225.223:80',
      'mvjxvmzc-dest:l15yq4x69d27@23.236.168.76:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.57.255.243:80',
      'mvjxvmzc-dest:l15yq4x69d27@104.227.173.20:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.154.84.87:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.147.28.210:80',
      'mvjxvmzc-dest:l15yq4x69d27@23.229.107.118:80',
      'mvjxvmzc-dest:l15yq4x69d27@23.254.90.7:80',
      'mvjxvmzc-dest:l15yq4x69d27@104.144.72.142:80',
      'mvjxvmzc-dest:l15yq4x69d27@23.229.125.81:80',
      'mvjxvmzc-dest:l15yq4x69d27@198.154.89.158:80',
      'mvjxvmzc-dest:l15yq4x69d27@23.254.90.193:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.158.187.211:80',
      'mvjxvmzc-dest:l15yq4x69d27@138.128.114.121:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.57.237.219:80',
      'mvjxvmzc-dest:l15yq4x69d27@69.58.12.116:80',
      'mvjxvmzc-dest:l15yq4x69d27@193.27.21.43:80',
      'mvjxvmzc-dest:l15yq4x69d27@192.156.217.99:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.87.249.134:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.128.245.135:80',
      'mvjxvmzc-dest:l15yq4x69d27@192.153.171.56:80',
      'mvjxvmzc-dest:l15yq4x69d27@193.23.245.127:80',
      'mvjxvmzc-dest:l15yq4x69d27@185.30.232.112:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.151.104.60:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.94.47.176:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.146.128.140:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.146.128.74:80',
      'mvjxvmzc-dest:l15yq4x69d27@192.166.153.69:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.154.56.190:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.128.76.116:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.8.134.180:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.255.148:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.134.187.17:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.152.202.63:80',
      'mvjxvmzc-dest:l15yq4x69d27@195.158.192.186:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.94.47.222:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.154.56.174:80',
      'mvjxvmzc-dest:l15yq4x69d27@185.164.57.169:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.154.58.10:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.255.23:80',
      'mvjxvmzc-dest:l15yq4x69d27@185.126.66.131:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.154.84.195:80',
      'mvjxvmzc-dest:l15yq4x69d27@193.27.19.212:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.136.173.207:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.152.200.82:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.195.223:80',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.56.139:80',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.56.38:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.154.84.222:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.152.200.130:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.80.79:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.255.220:80',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.127.235:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.9.122.112:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.94.47.109:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.80.229:80',
      'mvjxvmzc-dest:l15yq4x69d27@193.27.21.218:80',
      'mvjxvmzc-dest:l15yq4x69d27@5.182.32.150:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.152.202.36:80',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.231.71:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.43.21:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.40.115:80',
      'mvjxvmzc-dest:l15yq4x69d27@193.27.19.56:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.128.24.81:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.195.179:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.136.231.141:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.43.125:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.155.71.103:80',
      'mvjxvmzc-dest:l15yq4x69d27@171.22.145.253:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.134.187.254:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.155.70.1:80',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.94.92:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.195.237:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.155.71.37:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.136.231.171:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.136.231.168:80',
      'mvjxvmzc-dest:l15yq4x69d27@193.27.23.117:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.87.249.228:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.134.187.124:80',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.127.251:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.43.30:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.136.228.236:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.152.202.179:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.140.14.92:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.128.76.130:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.128.24.80:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.155.70.139:80',
      'mvjxvmzc-dest:l15yq4x69d27@193.39.245.31:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.60.144:80',
      'mvjxvmzc-dest:l15yq4x69d27@5.182.32.194:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.136.228.121:80',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.94.142:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.8.134.202:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.9.122.119:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.145.56.194:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.136.231.163:80',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.127.207:80',
      'mvjxvmzc-dest:l15yq4x69d27@185.164.57.140:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.136.228.254:80',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.56.96:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.84.97:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.9.122.118:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.145.56.222:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.155.70.224:80',
      'mvjxvmzc-dest:l15yq4x69d27@5.182.32.249:80',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.138.124:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.141.176.164:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.43.164:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.134.187.111:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.136.228.77:80',
      'mvjxvmzc-dest:l15yq4x69d27@193.27.21.132:80',
      'mvjxvmzc-dest:l15yq4x69d27@185.164.57.214:80',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.94.120:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.136.228.9:80',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.56.238:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.136.228.196:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.84.187:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.136.231.87:80',
      'mvjxvmzc-dest:l15yq4x69d27@5.182.32.220:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.134.187.93:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.128.76.78:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.155.70.103:80',
      'mvjxvmzc-dest:l15yq4x69d27@193.27.21.159:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.40.76:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.195.209:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.84.167:80',
      'mvjxvmzc-dest:l15yq4x69d27@85.209.129.79:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.141.176.237:80',
      'mvjxvmzc-dest:l15yq4x69d27@185.164.57.47:80',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.127.230:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.136.228.206:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.40.10:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.9.122.133:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.136.231.186:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.8.134.2:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.154.58.67:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.136.231.212:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.43.77:80',
      'mvjxvmzc-dest:l15yq4x69d27@193.27.21.111:80',
      'mvjxvmzc-dest:l15yq4x69d27@185.164.56.172:80',
      'mvjxvmzc-dest:l15yq4x69d27@182.54.239.10:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.60.220:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.87.249.80:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.8.134.198:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.60.205:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.43.102:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.43.189:80',
      'mvjxvmzc-dest:l15yq4x69d27@185.250.39.57:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.8.134.137:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.141.176.53:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.195.242:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.195.212:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.155.71.243:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.80.114:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.136.231.9:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.141.176.25:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.40.116:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.195.106:80',
      'mvjxvmzc-dest:l15yq4x69d27@185.164.57.242:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.145.56.65:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.195.87:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.134.187.233:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.155.70.82:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.152.202.70:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.136.231.44:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.43.75:80',
      'mvjxvmzc-dest:l15yq4x69d27@185.250.39.190:80',
      'mvjxvmzc-dest:l15yq4x69d27@185.250.39.129:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.43.130:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.136.231.185:80',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.138.175:80',
      'mvjxvmzc-dest:l15yq4x69d27@185.164.56.3:80',
      'mvjxvmzc-dest:l15yq4x69d27@182.54.239.167:80',
      'mvjxvmzc-dest:l15yq4x69d27@193.39.245.37:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.86.15.93:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.9.122.166:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.136.231.33:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.40.217:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.136.228.170:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.145.56.83:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.9.122.242:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.136.228.127:80',
      'mvjxvmzc-dest:l15yq4x69d27@182.54.239.54:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.84.26:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.9.122.105:80',
      'mvjxvmzc-dest:l15yq4x69d27@182.54.239.78:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.155.70.143:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.9.122.21:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.145.56.106:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.43.36:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.43.2:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.40.74:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.140.14.60:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.40.202:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.43.226:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.9.122.136:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.40.86:80',
      'mvjxvmzc-dest:l15yq4x69d27@182.54.239.185:80',
      'mvjxvmzc-dest:l15yq4x69d27@185.164.56.50:80',
      'mvjxvmzc-dest:l15yq4x69d27@85.209.129.192:80',
      'mvjxvmzc-dest:l15yq4x69d27@185.126.65.26:80',
      'mvjxvmzc-dest:l15yq4x69d27@193.39.245.100:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.9.122.170:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.152.202.128:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.94.47.216:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.40.83:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.142.28.19:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.43.111:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.94.47.57:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.142.28.250:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.43.99:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.94.47.53:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.142.28.69:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.43.206:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.145.56.212:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.60.224:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.87.249.88:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.152.202.129:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.87.248.196:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.140.14.6:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.43.83:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.87.249.157:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.87.248.222:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.87.249.208:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.152.202.134:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.155.71.225:80',
      'mvjxvmzc-dest:l15yq4x69d27@182.54.239.27:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.87.249.165:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.87.249.173:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.86.15.98:80',
      'mvjxvmzc-dest:l15yq4x69d27@182.54.239.98:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.255.21:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.60.92:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.94.47.102:80',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.138.54:80',
      'mvjxvmzc-dest:l15yq4x69d27@185.164.56.19:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.80.66:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.155.71.5:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.155.70.216:80',
      'mvjxvmzc-dest:l15yq4x69d27@182.54.239.61:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.60.174:80',
      'mvjxvmzc-dest:l15yq4x69d27@185.164.56.79:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.154.58.206:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.60.24:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.60.77:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.87.249.85:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.87.248.131:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.155.70.48:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.154.58.217:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.60.50:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.60.98:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.60.84:80',
      'mvjxvmzc-dest:l15yq4x69d27@182.54.239.159:80',
      'mvjxvmzc-dest:l15yq4x69d27@182.54.239.151:80',
      'mvjxvmzc-dest:l15yq4x69d27@182.54.239.183:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.87.248.30:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.60.124:80',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.138.63:80',
      'mvjxvmzc-dest:l15yq4x69d27@182.54.239.83:80',
      'mvjxvmzc-dest:l15yq4x69d27@182.54.239.64:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.86.15.137:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.94.47.113:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.80.113:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.86.15.20:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.86.15.174:80',
      'mvjxvmzc-dest:l15yq4x69d27@182.54.239.230:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.155.70.69:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.154.58.148:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.86.15.218:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.154.58.79:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.142.28.190:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.154.58.115:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.87.249.78:80',
      'mvjxvmzc-dest:l15yq4x69d27@182.54.239.63:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.86.15.12:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.94.47.154:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.84.24:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.155.70.19:80',
      'mvjxvmzc-dest:l15yq4x69d27@185.164.56.250:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.84.46:80',
      'mvjxvmzc-dest:l15yq4x69d27@182.54.239.92:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.152.202.64:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.60.209:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.84.122:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.60.60:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.145.56.69:80',
      'mvjxvmzc-dest:l15yq4x69d27@185.126.65.9:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.80.42:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.80.8:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.145.56.122:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.94.47.156:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.255.33:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.60.193:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.94.47.206:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.87.248.43:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.60.191:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.145.56.133:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.87.249.233:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.142.28.234:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.142.28.96:80',
      'mvjxvmzc-dest:l15yq4x69d27@182.54.239.140:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.255.169:80',
      'mvjxvmzc-dest:l15yq4x69d27@182.54.239.122:80',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.138.252:80',
      'mvjxvmzc-dest:l15yq4x69d27@182.54.239.208:80',
      'mvjxvmzc-dest:l15yq4x69d27@182.54.239.249:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.80.253:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.142.28.253:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.255.42:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.155.70.227:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.60.79:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.152.202.48:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.80.221:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.60.67:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.142.28.12:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.152.202.91:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.60.155:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.155.71.36:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.142.28.230:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.80.87:80',
      'mvjxvmzc-dest:l15yq4x69d27@182.54.239.165:80',
      'mvjxvmzc-dest:l15yq4x69d27@182.54.239.175:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.80.72:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.87.249.112:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.86.15.160:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.255.10:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.84.155:80',
      'mvjxvmzc-dest:l15yq4x69d27@182.54.239.19:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.154.58.96:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.152.202.144:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.152.202.176:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.255.34:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.255.16:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.255.201:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.255.254:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.255.143:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.255.2:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.255.152:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.255.1:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.255.82:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.255.117:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.255.181:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.255.253:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.255.154:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.255.109:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.255.86:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.255.213:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.255.200:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.255.141:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.86.15.163:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.86.15.99:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.86.15.212:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.86.15.253:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.86.15.45:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.86.15.44:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.86.15.85:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.86.15.82:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.86.15.1:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.86.15.64:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.86.15.83:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.86.15.51:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.86.15.10:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.86.15.234:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.86.15.115:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.86.15.236:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.86.15.179:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.86.15.189:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.60.189:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.60.178:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.60.242:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.60.16:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.60.157:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.60.122:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.130.60.20:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.92.247.209:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.92.247.71:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.92.247.150:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.92.247.171:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.92.247.8:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.92.247.69:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.92.247.235:80',
      'mvjxvmzc-dest:l15yq4x69d27@85.209.130.41:80',
      'mvjxvmzc-dest:l15yq4x69d27@85.209.130.82:80',
      'mvjxvmzc-dest:l15yq4x69d27@85.209.130.220:80',
      'mvjxvmzc-dest:l15yq4x69d27@85.209.130.8:80',
      'mvjxvmzc-dest:l15yq4x69d27@85.209.129.81:80',
      'mvjxvmzc-dest:l15yq4x69d27@85.209.129.227:80',
      'mvjxvmzc-dest:l15yq4x69d27@85.209.129.49:80',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.138.215:80',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.138.180:80',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.138.232:80',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.138.4:80',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.138.181:80',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.138.210:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.140.13.123:80',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.138.27:80',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.138.157:80',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.138.203:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.80.46:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.80.192:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.84.163:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.80.5:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.84.42:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.137.80.31:80',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.231.107:80',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.231.73:80',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.231.102:80',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.231.233:80',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.231.178:80',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.231.136:80',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.231.212:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.87.249.90:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.87.248.168:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.87.248.161:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.87.248.61:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.87.248.7:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.87.249.209:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.87.248.237:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.87.249.30:80',
      'mvjxvmzc-dest:l15yq4x69d27@185.126.65.3:80',
      'mvjxvmzc-dest:l15yq4x69d27@185.126.65.1:80',
      'mvjxvmzc-dest:l15yq4x69d27@185.126.65.24:80',
      'mvjxvmzc-dest:l15yq4x69d27@185.126.65.19:80',
      'mvjxvmzc-dest:l15yq4x69d27@185.126.65.6:80',
      'mvjxvmzc-dest:l15yq4x69d27@185.126.65.16:80',
      'mvjxvmzc-dest:l15yq4x69d27@185.126.65.23:80',
      'mvjxvmzc-dest:l15yq4x69d27@185.126.65.11:80',
      'mvjxvmzc-dest:l15yq4x69d27@185.126.65.5:80',
      'mvjxvmzc-dest:l15yq4x69d27@185.126.65.18:80',
      'mvjxvmzc-dest:l15yq4x69d27@185.126.65.2:80',
      'mvjxvmzc-dest:l15yq4x69d27@185.126.65.30:80',
      'mvjxvmzc-dest:l15yq4x69d27@185.126.65.15:80',
      'mvjxvmzc-dest:l15yq4x69d27@185.126.65.13:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.142.28.151:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.142.28.18:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.142.28.42:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.142.28.100:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.142.28.147:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.142.28.6:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.142.28.35:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.142.28.119:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.142.28.175:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.142.28.29:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.142.28.198:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.142.28.238:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.142.28.94:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.142.28.55:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.142.28.89:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.142.28.118:80',
      'mvjxvmzc-dest:l15yq4x69d27@182.54.239.67:80',
      'mvjxvmzc-dest:l15yq4x69d27@182.54.239.125:80',
      'mvjxvmzc-dest:l15yq4x69d27@182.54.239.75:80',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.231.249:80',
      'mvjxvmzc-dest:l15yq4x69d27@185.126.65.4:80',
      'mvjxvmzc-dest:l15yq4x69d27@185.126.65.17:80',
      'mvjxvmzc-dest:l15yq4x69d27@85.209.130.44:80',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.231.223:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.92.247.214:80',
      'mvjxvmzc-dest:l15yq4x69d27@185.126.65.12:80',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.231.137:80',
      'mvjxvmzc-dest:l15yq4x69d27@85.209.130.69:80',
      'mvjxvmzc-dest:l15yq4x69d27@45.92.247.78:80',
      'mvjxvmzc-dest:l15yq4x69d27@185.126.65.8:80',
      'mvjxvmzc-dest:l15yq4x69d27@85.209.129.190:80',
      'mvjxvmzc-dest:l15yq4x69d27@85.209.129.175:80',
      'mvjxvmzc-dest:l15yq4x69d27@185.126.65.14:80',
      'mvjxvmzc-dest:l15yq4x69d27@185.126.65.29:80',
      'mvjxvmzc-dest:l15yq4x69d27@185.126.65.27:80',
      'mvjxvmzc-dest:l15yq4x69d27@185.126.65.0:80',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.231.232:80',
      'mvjxvmzc-dest:l15yq4x69d27@185.126.65.7:80',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.231.66:80',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.231.43:80',
      'mvjxvmzc-dest:l15yq4x69d27@193.8.231.16:80',
    ]
  end

  def yt_json_info(lecture)
    video_data = `youtube-dl -j --format 18/22 '#{lecture.url}'`
    return JSON.parse(video_data) if video_data.present?

    video_data_from_proxy = `youtube-dl -j --format 18/22 '#{lecture.url}' --proxy #{proxy_list[Random.rand(499)]}`
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
