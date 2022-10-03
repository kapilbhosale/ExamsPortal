# == Schema Information
#
# Table name: raw_attendances
#
#  id         :bigint(8)        not null, primary key
#  data       :jsonb
#  processed  :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  org_id     :integer
#
# Indexes
#
#  index_raw_attendances_on_org_id  (org_id)
#

class RawAttendance < ApplicationRecord
  belongs_to :org
  after_create :process_raw_attendance

  def process_raw_attendance
    data.each_slice(500) do |logs|
      att_params = {}
      roll_numbers = logs.map {|r| r['deviceUserId']}
      students_by_roll_number = Student.where(org_id: org_id).where(roll_number: roll_numbers).index_by(&:roll_number)
      logs.each do |log|
        next if log.blank?

        student_id = students_by_roll_number[log['deviceUserId'].to_i]&.id
        next if student_id.blank?
        # need to keep track of students those are not found.

        time_entry = log['recordTime'].to_datetime
        time_in_seconds = time_entry.to_i

        sampled_time = (time_in_seconds / 120) * 120
        att_params[sampled_time] = {
          org_id: org_id,
          student_id: student_id,
          time_entry: time_entry,
          time_stamp: time_entry
        }
      end

      Attendance.create(att_params.values);
    end
    self.processed = true
    save
  end

end
