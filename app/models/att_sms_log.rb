# == Schema Information
#
# Table name: att_sms_logs
#
#  id            :bigint(8)        not null, primary key
#  absent_count  :integer
#  present_count :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  batch_id      :bigint(8)
#
# Indexes
#
#  index_att_sms_logs_on_batch_id  (batch_id)
#

class AttSmsLog < ApplicationRecord

  scope :today, -> { where('DATE(created_at) = ?', Date.today)}
end
