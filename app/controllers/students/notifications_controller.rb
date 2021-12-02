class Students::NotificationsController < Students::BaseController
  before_action :authenticate_student!

  def index
    @notifications = BatchNotification.includes(:notification)
    .where(batch: current_student.batches)
    .order(id: :desc)
    .page(params[:page] || 1)
    .per(params[:limit] || ITEMS_PER_PAGE)

    @notifications_data = @notifications.map(&:notification)
  end
end
