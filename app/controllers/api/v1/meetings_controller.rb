# frozen_string_literal: true

class Api::V1::MeetingsController < Api::V1::ApiController

  def index
    all_meetings = ZoomMeeting
      .includes(:batch_zoom_meetings)
      .where(batch_zoom_meetings: {batch_id: current_student.batches.ids})
      .where("datetime_of_meeting > '#{Time.now.beginning_of_day}' and datetime_of_meeting < '#{Time.now.beginning_of_day + 2.days}'")

    upcoming_meeting = ZoomMeeting
      .includes(:batch_zoom_meetings)
      .where(batch_zoom_meetings: {batch_id: current_student.batches.ids})
      .where("datetime_of_meeting > '#{Time.current - 30.minutes}' and datetime_of_meeting < '#{Time.current + 1.hour}'").first

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
