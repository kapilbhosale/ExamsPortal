
class Students::VideosController < Students::BaseController
  before_action :authenticate_student!, except: [:index]

  def index
  end

  def lectures
    lectures = VideoLecture.includes(:batches).where(batches: {id: current_student.batches}).order(id: :desc).group_by {|vl| vl.subject}
    @chem_videos = lectures['chem']
    @phy_videos = lectures['phy']
    @bio_videos = lectures['bio']
    @maths_videos = lectures['maths']
  end

  def show_lecture
    @video_url = "https://player.vimeo.com/video/#{params[:video_id]}?autoplay=1&color=fdbc1d&byline=0&portrait=0"
  end
end
