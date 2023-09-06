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
  # after_create :process_raw_attendance

  # need to refactor this. loaidng all students of an org is bad idea.
  def process_raw_attendance
    data.each_slice(500) do |logs|
      att_params = {}
      batch_ids = Batch.where(org_id: org_id).where.not(start_time: nil).ids

      batches_by_device_ids = get_batches_by_device_ids

      logs.each do |log|
        next if log.blank?
        next if log['emp_id'].length > 7

        REDIS_CACHE.set(log['machine_id'], DateTime.now.strftime("%d-%B-%Y %I:%M%p"), { ex: 60.minutes });
        roll_number = log['emp_id'].to_i

        students = Student.includes(:student_batches, :batches).where(roll_number: roll_number)
        student = nil

        if batches_by_device_ids[log['machine_id'].to_i].blank?
          student = students.where(batches: { id: batch_ids }).last
        else
          student = students.where(batches: { id: batches_by_device_ids[log['machine_id'].to_i] }).last
        end

        next if student.blank?
        next if student.roll_number.to_s.length > 7

        # need to keep track of students those are not found.
        # time_entry = log['punch_time'].to_datetime
        time_entry = Time.zone.parse(log['punch_time'])
        time_in_seconds = time_entry.to_i

        sampled_time = (time_in_seconds / 1.hour.seconds) * 1.hour.seconds
        att_params["#{student.id}-#{sampled_time}"] = {
          org_id: org_id,
          student_id: student.id,
          time_entry: time_entry,
          time_stamp: time_entry
        }
      end

      Attendance.create(att_params.values)
    end
    self.processed = true
    save
  end

  def get_batches_by_device_ids
    batches_by_device = {}
    Batch.where(org_id: org_id).where.not(start_time: nil).each do |batch|
      next if batch.device_ids.blank?

      batch.device_ids.split(',').each do |device_id|
        batches_by_device[device_id.to_i] ||= []
        batches_by_device[device_id.to_i] << batch.id
      end
    end

    batches_by_device
  end


  def data_mismatch?
    att_params = {}
    data.each_slice(500) do |logs|
      batch_ids = Batch.where(org_id: org_id).where.not(start_time: nil).ids

      batches_by_device_ids = get_batches_by_device_ids

      logs.each do |log|
        next if log.blank?
        next if log['emp_id'].length > 7

        REDIS_CACHE.set(log['machine_id'], DateTime.now.strftime("%d-%B-%Y %I:%M%p"), { ex: 60.minutes });
        roll_number = log['emp_id'].to_i

        students = Student.includes(:student_batches, :batches).where(roll_number: roll_number)
        student = nil

        if batches_by_device_ids[log['machine_id'].to_i].blank?
          student = students.where(batches: { id: batch_ids }).last
        else
          student = students.where(batches: { id: batches_by_device_ids[log['machine_id'].to_i] }).last
        end

        next if student.blank?
        next if student.roll_number.to_s.length > 7

        # need to keep track of students those are not found.
        # time_entry = log['punch_time'].to_datetime
        time_entry = Time.zone.parse(log['punch_time'])
        time_in_seconds = time_entry.to_i

        sampled_time = (time_in_seconds / 1.hour.seconds) * 1.hour.seconds
        att_params["#{student.id}-#{sampled_time}"] = {
          org_id: org_id,
          student_id: student.id,
          time_entry: time_entry,
          time_stamp: time_entry
        }
      end
    end

    input_student_ids = att_params.map { |k, v| v[:student_id] }.uniq
    att_students = Attendance.where(
      org_id: org_id,
      created_at: self.created_at.beginning_of_day..self.created_at.end_of_day,
      student_id: input_student_ids
    )

    if input_student_ids.count != att_students.count
      return {
        input_count: input_student_ids.count,
        att_count: att_students.count,
        input_student_ids: input_student_ids.uniq.sort,
        created_student_ids: att_students.pluck(:student_id).uniq.sort
      }
    end

    false
  end
end


# ra_mis_ids = []
# RawAttendance.where(created_at: (Time.now - 1.day).beginning_of_day..(Time.now - 1.day).end_of_day).each do |ra|
#   putc "."
#   ra_data = ra.data_mismatch?
#   if ra_data != false
#     ra_mis_ids << ra.id if ra_data[:input_count] > ra_data[:att_count]
#   end
# end


# roll_number = "8571245"
# target_ra_ids = []
# RawAttendance.where(created_at: (Time.now).beginning_of_day..(Time.now).end_of_day).each do |ra|
#   putc "."
#   ra.data.each do |log|
#     target_ra_ids << ra.id if log['emp_id'] == roll_number
#   end
# end