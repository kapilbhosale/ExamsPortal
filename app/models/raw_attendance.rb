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


  # need to refactor this. loaidng all students of an org is bad idea.
  def process_raw_attendance
    data.each_slice(500) do |logs|
      att_params = {}
      batch_ids = Batch.where(org_id: org_id).where.not(start_time: nil).ids
      student_ids = StudentBatch.where(batch_id: batch_ids).pluck(:student_id)
      students_by_roll_number = {}
      Student.where(org_id: org_id).where(id: student_ids).each do |student|
        students_by_roll_number[student.roll_number] = student.id
      end

      batches_by_device_ids = {}
      students_by_roll_number_by_batch = {}
      Batch.where(org_id: org_id).where.not(start_time: nil).each do |batch|
        next if batch.device_ids.blank?

        batch.device_ids.split(',').each do |device_id|
          batches_by_device_ids[device_id.to_i] ||= []
          batches_by_device_ids[device_id.to_i] << batch.id
        end
        s_ids = StudentBatch.where(batch_id: batch.id).pluck(:student_id)
        r_data = {}
        Student.where(org_id: org_id).where(id: s_ids).each do |student|
          r_data[student.roll_number] = student.id
        end
        students_by_roll_number_by_batch[batch.id] = r_data
      end

      logs.each do |log|
        next if log.blank?

        REDIS_CACHE.set(log['machine_id'], DateTime.now.strftime("%d-%B-%Y %I:%M%p"), { ex: 60.minutes });

        student_id = nil
        if batches_by_device_ids[log['machine_id'].to_i].blank?
          student_id = students_by_roll_number[log['emp_id'].to_i]
        else
          batches_by_device_ids[log['machine_id'].to_i].each do |batch_id|
            student_id = students_by_roll_number_by_batch[batch_id][log['emp_id'].to_i]
            break if student_id.present?
          end
        end

        next if student_id.blank?
        # need to keep track of students those are not found.

        # time_entry = log['punch_time'].to_datetime
        time_entry = Time.zone.parse(log['punch_time'])
        time_in_seconds = time_entry.to_i

        sampled_time = (time_in_seconds / 1.hour.seconds) * 1.hour.seconds
        att_params["#{student_id}-#{sampled_time}"] = {
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
