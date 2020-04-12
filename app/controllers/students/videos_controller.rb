
class Students::VideosController < Students::BaseController
  before_action :authenticate_student!, except: [:index]

  def index
  end

  def lectures
    @chem_videos = VideoLecture.chem.order(id: :desc)
    @phy_videos = VideoLecture.phy.order(id: :desc)
    @bio_videos = VideoLecture.bio.order(id: :desc)
    @maths_videos = VideoLecture.maths.order(id: :desc)
  end

  def show_lecture
    @video_url = "https://player.vimeo.com/video/#{params[:video_id]}?autoplay=1&color=fdbc1d&byline=0&portrait=0"
  end
end
