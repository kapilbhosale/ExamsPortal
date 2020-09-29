class Admin::ZoomMeetingsController < Admin::BaseController

  def new
    @batches = Batch.where(org: current_org, id: current_admin.batches&.ids).all_batches
  end

  def edit
    @zoom_meeting = ZoomMeeting.find_by(org: current_org, id: params[:id])
    @selected_batch_ids = @zoom_meeting.batches.ids
    @batches = Batch.where(org: current_org, id: current_admin.batches&.ids).all_batches
  end

  def update
    meeting = ZoomMeeting.find_by(org: current_org, id: params[:id])
    if meeting && validate_meeting_params
      meeting.zoom_meeting_id = params[:zoom_meeting_id]
      meeting.password = params[:password]
      meeting.subject = params[:subject]
      meeting.teacher_name = params[:teacher_name]
      meeting.datetime_of_meeting = params[:datetime_of_meeting]
      meeting.live_type = ZoomMeeting.live_types[params[:live_type].to_s]
      meeting.vimeo_live_url = params[:vimeo_live_url]
      if meeting.save
        if params[:batches].present?
          BatchZoomMeeting.where(zoom_meeting_id: meeting.id).destroy_all
          params[:batches].each do |batch_id|
            BatchZoomMeeting.create(batch_id: batch_id, zoom_meeting_id: meeting.id)
          end
        end
        flash[:success] = "Meeting updated, successfully"
      else
        flash[:error] = "Error in updating Meeting.."
      end
    else
      flash[:error] = "No Meeting found."
    end

    redirect_to "#{admin_android_apps_path}#zoom_meetings"
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
      meeting.live_type = ZoomMeeting.live_types[params[:live_type].to_s]
      meeting.vimeo_live_url = params[:vimeo_live_url]
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

    redirect_to "#{admin_android_apps_path}#zoom_meetings"
  end

  def destroy
    meeting = ZoomMeeting.find_by(org: current_org, id: params[:id])
    meeting.destroy if meeting.present?
    flash[:success] = "Meeting deleted, successfully"

    redirect_to "#{admin_android_apps_path}#zoom_meetings"
  end

  def validate_meeting_params
    if(params[:live_type] == 'zoom')
      params[:zoom_meeting_id].present? && params[:password].present? && params[:datetime_of_meeting].present?
    else
      params[:vimeo_live_url].present?
    end
  end
end
