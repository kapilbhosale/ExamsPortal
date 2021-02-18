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

class RawAttendance < ApplicationRecord
  belongs_to :org
  after_create :process_raw_attendance

  def process_raw_attendance
    att_logs = data.split('|')
    att_logs.each_slice(500) do |logs|
      att_params = {}
      logs.each do |log|
        next if log.blank?

        student_id = log.split(',')[0]
        time_entry = log.split(',')[1]
        time_in_seconds = time_entry.to_i / 1000

        sampled_time = (time_in_seconds / 120) * 120
        att_params[sampled_time] = {
          org_id: org_id,
          student_id: student_id,
          time_entry: get_time_from_int_milis(time_in_seconds),
          time_stamp: time_in_seconds
        }
      end

      Attendance.create(att_params.values);
    end
    self.processed = true
    save
  end

  def get_time_from_int_milis(value)
    DateTime.strptime(value.to_s, '%s')
  end
end
