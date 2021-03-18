class Admin::NotificationsController < Admin::BaseController
  ITEMS_PER_PAGE = 20
  def index
    @notifications = Notification
      .includes(:org)
      .where(org: current_org)
      .includes(:batches, :batch_notifications)
      .where(batches: {id: current_admin.batches&.ids})
      .order(id: :desc)
      .page(params[:page])
      .per(params[:limit] || ITEMS_PER_PAGE)
  end

  def new
    @batches_with_group = Batch.where(org: current_org, id: current_admin.batches&.ids).all_batches.group_by(&:batch_group_id)
    @batch_groups = BatchGroup.where(org: current_org).index_by(&:id)
  end

  def edit
    @notification = Notification.find_by(org: current_org, id: params[:id])
    @batches_with_group = Batch.where(org: current_org, id: current_admin.batches&.ids).all_batches.group_by(&:batch_group_id)
    @batch_groups = BatchGroup.where(org: current_org).index_by(&:id)
  end

  def update
    notification = Notification.find_by(org: current_org, id: params[:id])
    if notification && validate_notification_params
      notification.title = params[:title]
      notification.description = params[:description]
      if notification.save
        if params[:batches].present?
          BatchNotification.where(notification_id: notification.id).destroy_all
          params[:batches].each do |batch_id|
            BatchNotification.create(batch_id: batch_id, notification_id: notification.id)
            clear_cache(batch_id)
          end
        end
        flash[:success] = "Notification updated, successfully"
      else
        flash[:error] = "Error in updating notification.."
      end
    end

    redirect_to "#{admin_android_apps_path}#notifications"
  end

  def create
    notification = Notification.new
    if validate_notification_params
      notification.title = params[:title]
      notification.description = params[:description]
      notification.org_id = current_org.id
      if notification.save
        if params[:batches].present?
          params[:batches].each do |batch_id|
            BatchNotification.create(batch_id: batch_id, notification_id: notification.id)
            clear_cache(batch_id)
          end
          notification.send_push_notifications
        end
        flash[:success] = "Notification created, successfully"
      else
        flash[:error] = "Error in creating PDF.."
      end
    end

    redirect_to "#{admin_android_apps_path}#notifications"
  end

  def destroy
    notification = Notification.find_by(org: current_org, id: params[:id])
    notification.destroy if notification.present?
    flash[:success] = "Notification deleted, successfully"

    redirect_to "#{admin_android_apps_path}#notifications"
  end

  def validate_notification_params
    params[:title].present? && params[:description].present?
  end

  def clear_cache(batch_id)
    cache_key = "BatchNotifications-batch-id-#{batch_id}"
    REDIS_CACHE.del(cache_key)
  end
end