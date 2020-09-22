# frozen_string_literal: true

class Api::V1::NotificationsController < Api::V1::ApiController

  def index
    @notifications = BatchNotification.includes(:notification).where(batch: current_student.batches).order(id: :desc).map(&:notification)
    render json: notifications_json, status: :ok
  end

  private

  def notifications_json
    @notifications.map do |notification|
      {
        title: notification.title,
        description: notification.description,
        added_on: notification.created_at
      }
    end
  end
end
