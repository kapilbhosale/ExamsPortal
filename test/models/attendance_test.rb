# == Schema Information
#
# Table name: attendances
#
#  id         :bigint(8)        not null, primary key
#  att_type   :integer          default("rfid")
#  time_entry :datetime
#  time_stamp :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  org_id     :bigint(8)
#  student_id :bigint(8)
#
# Indexes
#
#  index_attendances_on_org_id      (org_id)
#  index_attendances_on_student_id  (student_id)
#

require 'test_helper'

class AttendanceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
