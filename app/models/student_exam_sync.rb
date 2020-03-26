# == Schema Information
#
# Table name: student_exam_syncs
#
#  id          :bigint(8)        not null, primary key
#  sync_data   :jsonb
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  exams_id    :bigint(8)
#  students_id :bigint(8)
#
# Indexes
#
#  index_student_exam_syncs_on_exams_id     (exams_id)
#  index_student_exam_syncs_on_students_id  (students_id)
#

class StudentExamSync < ApplicationRecord
end
