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
# Foreign Keys
#
#  fk_rails_...  (omr_batch_id => omr_batches.id)
#  fk_rails_...  (omr_student_id => omr_students.id)
#

require 'test_helper'

class Omr::StudentBatchTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
