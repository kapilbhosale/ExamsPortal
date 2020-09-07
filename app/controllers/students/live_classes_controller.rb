
class Students::LiveClassesController < Students::BaseController
  before_action :authenticate_student!

  def index
    @live_classes = ZoomMeeting
      .includes(:batch_zoom_meetings)
      .where(batch_zoom_meetings: {batch_id: current_student.batches.ids})
      .where("datetime_of_meeting > ?", Time.now.beginning_of_day)
      .where("datetime_of_meeting < ?", Time.now.beginning_of_day + 2.days)
      .order(id: :desc) || []
  end

  def show
    @vimeo_live = ZoomMeeting.find_by(id: params[:id])
    @student = current_student
    @video_url = @vimeo_live.vimeo_live_url
    @messages = Message.where(messageable: @vimeo_live)
  end

end
