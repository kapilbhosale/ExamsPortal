# frozen_string_literal: true

class Api::V1::NotificationsController < Api::V1::ApiController
  USE_CACHE = true
  def index
    if current_student.batches&.ids&.count == 1
      batch_id = current_student.batches&.ids&.first
      cache_key = "BatchNotifications-batch-id-#{batch_id}"

      batch_notifs = REDIS_CACHE.get(cache_key)
      if USE_CACHE && batch_notifs.present?
        render json: JSON.parse(batch_notifs), status: :ok and return
      else
        @notifications = Notification.where('notifications.created_at >= ?', Time.current - 15.days).includes(:batch_notifications, :batches).where(batches: {id: current_student.batches&.ids}).order(id: :desc)
        batch_notifs = notifications_json
        REDIS_CACHE.set(cache_key, JSON.dump(batch_notifs), { ex: 1.day })
        render json: batch_notifs, status: :ok and return
      end
    end
    @notifications = Notification.where('notifications.created_at >= ?', Time.current - 15.days).includes(:batch_notifications, :batches).where(batches: {id: current_student.batches&.ids}).order(id: :desc)
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
