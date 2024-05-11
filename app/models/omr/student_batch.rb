# == Schema Information
#
# Table name: omr_student_batches
#
#  id             :bigint(8)        not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  omr_batch_id   :bigint(8)
#  omr_student_id :bigint(8)
#
# Indexes
#
#  index_omr_student_batches_on_omr_batch_id    (omr_batch_id)
#  index_omr_student_batches_on_omr_student_id  (omr_student_id)
#

class Omr::StudentBatch < ApplicationRecord
  belongs_to :omr_student, class_name: 'Omr::Student'
  belongs_to :omr_batch, class_name: 'Omr::Batch'

  validates :omr_student_id, uniqueness: { scope: :omr_batch_id }
end
