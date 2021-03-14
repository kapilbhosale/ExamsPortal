class Students::NotificationsController < Students::BaseController
  before_action :authenticate_student!

  def index
    @notifications = BatchNotification.includes(:notification)
    .where(batch: current_student.batches)
    .page(params[:page])
    .per(params[:limit] || ITEMS_PER_PAGE)
    
    @notifications_data = @notifications.map(&:notification)
  end
end
