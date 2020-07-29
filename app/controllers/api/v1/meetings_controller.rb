# frozen_string_literal: true

class Api::V1::MeetingsController < Api::V1::ApiController

  def index
    all_meetings = BatchZoomMeeting.includes(:zoom_meeting).where(batch: current_student.batches).map(&:zoom_meeting)
    upcoming_meeting = ZoomMeeting
      .includes(:batch_zoom_meetings)
      .where(batch_zoom_meetings: {batch_id: current_student.batches.ids})
      .where("zoom_meetings.datetime_of_meeting > '#{Time.current}' and zoom_meetings.datetime_of_meeting < '#{Time.current + 1.hour}'")

    meetings_data = {
      zoom_app_key: '5oNVTIJJEMjDO4HiQuk0Ao476WcnHwTD43wB',
      zoom_app_secret: 'zi6R0FMfQVhNIjXFUFycm8u0MvGjJhBdeXge',
      zoom_domain: 'zoom.us',
      upcoming: upcoming_meeting.present? ? upcoming_meeting : nil,
      all: all_meetings
    }
    render json: meetings_data
  end
end
