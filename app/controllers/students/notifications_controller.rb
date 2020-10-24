class Students::NotificationsController < Students::BaseController
  before_action :authenticate_student!

  def index
    @notifications = BatchNotification.includes(:notification).where(batch: current_student.batches).map(&:notification)
  end
end
