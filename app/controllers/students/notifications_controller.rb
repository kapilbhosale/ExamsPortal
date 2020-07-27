class Students::NotificationsController < Students::BaseController
  def index
    @notifications = BatchNotification.includes(:notification).where(batch: current_student.batches).map(&:notification)
  end
end
