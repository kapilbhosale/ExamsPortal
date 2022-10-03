# == Schema Information
#
# Table name: notifications
#
#  id          :bigint(8)        not null, primary key
#  description :string
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  org_id      :bigint(8)
#
# Indexes
#
#  index_notifications_on_org_id  (org_id)
#

class Notification < ApplicationRecord
  has_many :batch_notifications, dependent: :destroy
  has_many :batches, through: :batch_notifications
  belongs_to :org

  def send_push_notifications
    fcm = FCM.new(org.fcm_server_key)
    batches.each do |batch|
      batch.students.where.not(fcm_token: nil).pluck(:fcm_token).each_slice(500) do |reg_ids|
        fcm.send(reg_ids, push_options)
      end
    end
  end

  def push_options
    {
      priority: 'high',
      data: {
        message: "New Notification Added"
      },
      notification: {
        body: self.description,
        title: "New Notification - '#{self.title}'"
      }
    }
  end
end
