# == Schema Information
#
# Table name: exam_batches
#
#  id         :bigint(8)        not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  batch_id   :bigint(8)
#  exam_id    :bigint(8)
#
# Indexes
#
#  index_exam_batches_on_batch_id  (batch_id)
#  index_exam_batches_on_exam_id   (exam_id)
#

class ExamBatch < ApplicationRecord
  belongs_to :exam
  belongs_to :batch
end
