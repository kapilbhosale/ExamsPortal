
class Students::VideosController < Students::BaseController
  before_action :authenticate_student!
  layout 'student_exam_layout', only: [:show_lecture]

  before_action :check_valid_rcc_request, only: [:category_videos, :lectures, :show_lecture]

  def index
  end

  def category_videos
    all_vls = VideoLecture.includes(:batches)
    .where(org_id: current_org.id)
    .where(batches: {id: current_student.batches.ids})
    .where(genre_id: params[:id].to_i)
    .where.not(laptop_vimeo_id: nil)

    lectures = all_vls.where(enabled: true).order(id: :desc)

    @lectures_data = {}
    lectures.each do |lect|
      next if lect.publish_at.present? && lect.publish_at > Time.current

      @lectures_data[lect.subject&.name] ||= []
      @lectures_data[lect.subject&.name] << lect
    end

    disabled_lectures = all_vls.where(enabled: false).order(id: :desc)

    disabled_lectures.each do |vl|
      next if vl.publish_at.present? && vl.publish_at > Time.current

      svfs = StudentVideoFolder.where(student_id: current_student.id).index_by(&:genre_id)
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

      @lectures_data[vl.subject&.name] ||= []
      @lectures_data[vl.subject&.name] << vl
    end
  end

  def lectures
    all_vls = VideoLecture
      .includes(:genre, :subject, :batches)
      .where(org_id: current_org.id)
      .where(batches: { id: current_student.batches.ids })
      .where.not(laptop_vimeo_id: nil)

    video_lectures = all_vls.where(enabled: true)
    @categories_data = {}

    if current_org.subdomain == 'exams' && current_student.pending_amount.present? && current_student.block_videos?
      render json: {}, status: :ok and return
    end

    video_lectures.each do |vl|
      next if vl.publish_at.present? && vl.publish_at > Time.current

      subject_name = vl.subject&.name
      @categories_data[subject_name] ||= {}
      @categories_data[subject_name][vl.genre_id] ||= {
        id: vl.genre_id || 0,
        name: vl&.genre&.name || 'Default',
        count: 0,
        new: 0
      }
      @categories_data[subject_name][vl.genre_id][:count] += 1
      if vl.created_at >= Time.zone.now.beginning_of_day
        @categories_data[subject_name][vl.genre_id][:new] += 1
      end
    end

    # considering enalbed false videos for students admitted late.
    # starts here
    video_lectures = all_vls.where(enabled: false)
    video_lectures.each do |vl|
      next if vl.publish_at.present? && vl.publish_at > Time.current

      svfs = StudentVideoFolder.where(student_id: current_student.id).index_by(&:genre_id)
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
      @categories_data[subject_name] ||= {}
      @categories_data[subject_name][vl.genre_id] ||= {
        id: vl.genre_id,
        name: vl&.genre&.name || 'Default',
        count: 0,
        new: 0
      }
      @categories_data[subject_name][vl.genre_id][:count] += 1
      if vl.created_at >= Time.zone.now.beginning_of_day
        @categories_data[subject_name][vl.genre_id][:new] += 1
      end
    end
  end

  # def category_videos
  #   video_lectures = VideoLecture.includes(:batches)
  #                                .where(org_id: current_org.id)
  #                                .where(batches: {id: current_student.batches.ids}, genre_id: params[:id].to_i)
  #                                .where(enabled: true)
  #                                .order(id: :desc)
  #   lectures_json = lectures_json(video_lectures)
  #   lectures_json = lectures_json.delete_if { |_, value| value.blank? }

  #   render json: lectures_json, status: :ok
  # end

  def show_lecture
    # @student = current_student
    # @video_lecture = VideoLecture.find_by(laptop_vimeo_id: params[:video_id])
    # @messages = Message.where(messageable: @video_lecture)
    @video_url = "https://player.vimeo.com/video/#{params[:video_id]}?autoplay=1&color=fdbc1d&byline=0&portrait=0"
    @yt_playable_link = nil
    # disabling video from ytdl
    if false && current_org.subdomain == 'exams'
      lecture = VideoLecture.where('video_id = ? OR laptop_vimeo_id = ?', params[:video_id].to_s, params[:video_id].to_s).last
      if REDIS_CACHE&.get("lecture-#{lecture&.id}-url_hd").present?
        @yt_playable_link = REDIS_CACHE&.get("lecture-#{lecture&.id}-url_hd")
      else
        @yt_playable_link = REDIS_CACHE&.get("lecture-#{lecture&.id}-url_sd")
      end
    end
  end

  def pay_vimeo
  end

  def play_yt
  end

  def play_yt_video
    render json: { id: 'gfC8Y66tR6o'}
    # redirect_to 'https://www.youtube.com/watch?v=gfC8Y66tR6o', status: 302
  end

  private

  def check_valid_rcc_request
    @is_rcc = current_org.subdomain == 'exams'
    @req_from_electron = request.user_agent.include?('Electron') && cookies['electron'] == "YES-9890"
    @req_from_browser = !@req_from_electron
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
