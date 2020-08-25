
class Students::LiveClassesController < Students::BaseController
  before_action :authenticate_student!
  layout false, only: [:show_lecture]

  def index
  end

  def show
    @vimeo_live = ZoomMeeting.find_by(id: params[:id])
    @video_url = "https://player.vimeo.com/video/#{params[:video_id]}?autoplay=1&color=fdbc1d&byline=0&portrait=0"
  end

end
