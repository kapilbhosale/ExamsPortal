# == Schema Information
#
# Table name: attendances
#
#  id         :bigint(8)        not null, primary key
#  att_type   :integer          default(0)
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

# frozen_string_literal: true
class Attendance < ApplicationRecord
  belongs_to :org
  belongs_to :student

  validates :student_id, uniqueness: { scope: :time_stamp }

  enum att_type: { rfid: 0, online: 1, other: 2 }
end


# # script to create attendance
# student_ids = [1,2,3,5,6,7]
# year = 2021
# month = 01
# hh = 10
# mm = [05, 10, 20, 30, 40, 50]

# # Time.local(2021, 02, 13, 12, 50)

# student_ids.each do |student_id|
#   1.upto(31).each do |i|
#     time_entry = Time.local(year, month, i, hh, mm.sample)
#     Attendance.create({
#       time_entry: time_entry,
#       time_stamp: time_entry.to_i,
#       org_id: 1,
#       student_id: student_id
#     })
#   end
# end