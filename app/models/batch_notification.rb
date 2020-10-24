# == Schema Information
#
# Table name: batch_notifications
#
#  id              :bigint(8)        not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  batch_id        :bigint(8)
#  notification_id :bigint(8)
#
# Indexes
#
#  index_batch_notifications_on_batch_id         (batch_id)
#  index_batch_notifications_on_notification_id  (notification_id)
#

class BatchNotification < ApplicationRecord
  belongs_to :batch
  belongs_to :notification
end
