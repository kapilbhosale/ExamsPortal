# == Schema Information
#
# Table name: sms_logs
#
#  id         :bigint(8)        not null, primary key
#  message    :string
#  mobile     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  org_id     :bigint(8)
#  student_id :bigint(8)
#
# Indexes
#
#  index_sms_logs_on_mobile      (mobile)
#  index_sms_logs_on_org_id      (org_id)
#  index_sms_logs_on_student_id  (student_id)
#

class SmsLog < ApplicationRecord
  belongs_to :org
  belongs_to :student, optional: true
end
