# frozen_string_literal: true

class Api::V1::MeetingsController < Api::V1::ApiController

  def index
    all_meetings = ZoomMeeting
      .includes(:batch_zoom_meetings)
      .where(batch_zoom_meetings: {batch_id: current_student.batches.ids})
      .where("datetime_of_meeting > ?", Time.now.beginning_of_day)
      .where("datetime_of_meeting < ?", Time.now.beginning_of_day + 2.days)
      .order(id: :desc)

    upcoming_meeting = ZoomMeeting
      .includes(:batch_zoom_meetings)
      .where(batch_zoom_meetings: {batch_id: current_student.batches.ids})
      .where("datetime_of_meeting > ?", Time.current - 30.minutes)
      .where("datetime_of_meeting <= ?", Time.current + 1.hour)
      .first

    all_meetings_data = all_meetings.map do |meeting|
      meeting.attributes.merge(
        {
          zoom_app_key: '5oNVTIJJEMjDO4HiQuk0Ao476WcnHwTD43wB',
          zoom_app_secret: 'zi6R0FMfQVhNIjXFUFycm8u0MvGjJhBdeXge',
        }
      )
    end

    upcoming_meeting_data = upcoming_meeting.attributes.merge(
      {
        zoom_app_key: 'svepWfie7Uc3WN9roeXnxCxzSuVZJRFDa1ED',
        zoom_app_secret: 'KrKCtRfptKM4RpPP8zt6QfaRKwGE1K8jV1h7',
      }
    )

    meetings_data = {
      zoom_app_key: '5oNVTIJJEMjDO4HiQuk0Ao476WcnHwTD43wB',
      zoom_app_secret: 'zi6R0FMfQVhNIjXFUFycm8u0MvGjJhBdeXge',
      zoom_domain: 'zoom.us',
      upcoming: upcoming_meeting_data.present? ? upcoming_meeting_data : nil,
      all: all_meetings_data
    }
    render json: meetings_data
  end
end
