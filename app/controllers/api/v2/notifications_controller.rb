class Api::V2::NotificationsController < Api::V2::ApiController
  ITEMS_PER_PAGE = 20
  def index
    page = (params[:page] || 1).to_i

    notifications = Notification.includes(:batch_notifications, :batches).where(batches: {id: current_student.batches&.ids})
    total = notifications.count
    notifications = notifications.order(id: :desc).page(page).per(params[:limit] || ITEMS_PER_PAGE).map do |notification|
      {
        title: notification.title,
        description: notification.description,
        added_on: notification.created_at.strftime("%d-%b-%y %I:%M%p")
      }
    end

    if notifications.blank?
      render json: {
        page: page,
        page_size: ITEMS_PER_PAGE,
        total_page: 0,
        count: 0,
        data: []
      } and return
    end

  render json: {
    page: page,
    page_size: ITEMS_PER_PAGE,
    total_page: (total / ITEMS_PER_PAGE.to_f).ceil,
    count: total,
    data: notifications
  }
  end
end
