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
  has_many :batch_notifications
  has_many :batches, through: :batch_notifications
  belongs_to :org
end
