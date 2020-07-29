class Admin::ZoomMeetingsController < Admin::BaseController

  def new
    @batches = Batch.where(org: current_org).all_batches
  end

  def edit
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
          end
        end
        flash[:success] = "Notification updated, successfully"
      else
        flash[:error] = "Error in updating notification.."
      end
    end
    redirect_to admin_android_apps_path
  end

  def create
    meeting = ZoomMeeting.new
    if validate_meeting_params
      meeting.zoom_meeting_id = params[:zoom_meeting_id]
      meeting.password = params[:password]
      meeting.subject = params[:subject]
      meeting.teacher_name = params[:teacher_name]
      meeting.datetime_of_meeting = params[:datetime_of_meeting]
      meeting.org_id = current_org.id
      if meeting.save
        if params[:batches].present?
          params[:batches].each do |batch_id|
            BatchZoomMeeting.create(batch_id: batch_id, zoom_meeting_id: meeting.id)
          end
        end
        flash[:success] = "Meeting created, successfully"
      else
        flash[:error] = "Error in creating Meeting.."
      end
    end
    redirect_to admin_android_apps_path
  end

  def destroy
    meeting = ZoomMeeting.find_by(org: current_org, id: params[:id])
    meeting.destroy if meeting.present?
    flash[:success] = "Meeting deleted, successfully"
    redirect_to admin_android_apps_path
  end

  def validate_meeting_params
    params[:zoom_meeting_id].present? && params[:password].present? && params[:datetime_of_meeting].present?
  end
end
