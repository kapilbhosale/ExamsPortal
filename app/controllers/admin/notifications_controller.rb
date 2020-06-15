class Admin::NotificationsController < Admin::BaseController
  #  pdf controller section
  def new
    @batches = Batch.where(org: current_org).all_batches
  end

  def edit
    @notification = Notification.find_by(org: current_org, id: params[:id])
    @batches = Batch.where(org: current_org).all_batches
  end

  def update
    notification = Notification.find_by(org: current_org, id: params[:id])
    if params[:title].present? && params[:description].present?
      notification.title = params[:title]
      notification.description = params[:description]
      if notification.save
        if params[:batches].present?
          BatchNotification.where(notification_id: notification.id).destroy_all
          params[:batches].each do |batch_id|
            BatchNotification.create(batch_id: batch_id, notification_id: notification.id)
          end
          flash[:success] = "Notification updated, successfully"
        end
      else
        flash[:error] = "Error in updating notification.."
      end
    end
    redirect_to admin_android_apps_path

  end

  def create
    notification = Notification.new
    if params[:title].present? && params[:description].present?
      notification.title = params[:title]
      notification.description = params[:description]
      notification.org_id = current_org.id
      if notification.save
        if params[:batches].present?
          params[:batches].each do |batch_id|
            BatchNotification.create(batch_id: batch_id, notification_id: notification.id)
          end
          flash[:success] = "Notification created, successfully"
        end
      else
        flash[:error] = "Error in creating PDF.."
      end
    end
    redirect_to admin_android_apps_path
  end

  def destroy
    notification = Notification.find_by(org: current_org, id: params[:id])
    notification.destroy if notification.present?
    flash[:success] = "Notification deleted, successfully"
    redirect_to admin_android_apps_path
  end
end