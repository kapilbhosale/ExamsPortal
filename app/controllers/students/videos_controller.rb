
class Students::VideosController < Students::BaseController
  before_action :authenticate_student!
  layout false, only: [:show_lecture]

  def index
  end

  def lectures
    lectures = VideoLecture
      .where(org: current_org)
      .includes(:batches)
      .where(batches: {id: current_student.batches})
      .where(enabled: true)
      .where.not(laptop_vimeo_id: nil)
      .order(id: :desc)

    lectures_data = {}
    lectures.each do |lect|
      lectures_data[lect.subject] ||= []
      lectures_data[lect.subject] << lect
    end
    @chem_videos = lectures_data['chem']
    @phy_videos = lectures_data['phy']
    @bio_videos = lectures_data['bio']
    @maths_videos = lectures_data['maths']
  end

  def show_lecture
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
end
