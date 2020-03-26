# == Schema Information
#
# Table name: student_exam_syncs
#
#  id         :bigint(8)        not null, primary key
#  sync_data  :jsonb
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  exam_id    :bigint(8)
#  student_id :bigint(8)
#
# Indexes
#
#  index_student_exam_syncs_on_exam_id     (exam_id)
#  index_student_exam_syncs_on_student_id  (student_id)
#

class StudentExamSync < ApplicationRecord
end
