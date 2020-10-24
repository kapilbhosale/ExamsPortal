
class Students::VideosController < Students::BaseController
  before_action :authenticate_student!
  layout false, only: [:show_lecture]

  def index
  end

  def category_videos
    lectures = VideoLecture
      .where(org: current_org)
      .includes(:batches)
      .where(batches: {id: current_student.batches.ids}, genre_id: params[:id].to_i)
      .where(enabled: true)
      .where.not(laptop_vimeo_id: nil)
      .order(id: :desc)

    @lectures_data = {}
    lectures.each do |lect|
      next if lect.publish_at.present? && lect.publish_at > Time.current

      @lectures_data[lect.subject&.name] ||= []
      @lectures_data[lect.subject&.name] << lect
    end
  end

  def lectures
    video_lectures = VideoLecture
      .includes(:genre, :subject, :batches)
      .where(org_id: current_org.id)
      .where(batches: { id: current_student.batches.ids })
      .where(enabled: true)
      .where.not(laptop_vimeo_id: nil)
    @categories_data = {}
    video_lectures.all.each do |vl|
      next if vl.publish_at.present? && vl.publish_at > Time.current

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
