# == Schema Information
#
# Table name: student_batches
#
#  id         :bigint(8)        not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  batch_id   :bigint(8)
#  student_id :bigint(8)
#
# Indexes
#
#  index_student_batches_on_batch_id    (batch_id)
#  index_student_batches_on_student_id  (student_id)
#

class StudentBatch < ApplicationRecord
  belongs_to  :student
  belongs_to  :batch
end
