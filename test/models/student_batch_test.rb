# == Schema Information
#
# Table name: student_batches
#
#  id         :bigint(8)        not null, primary key
#  student_id :bigint(8)
#  batch_id   :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class StudentBatchTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
