# == Schema Information
#
# Table name: omr_student_tests
#
#  id             :bigint(8)        not null, primary key
#  data           :jsonb
#  rank           :integer
#  score          :integer          default(0)
#  student_ans    :jsonb
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  child_test_id  :integer
#  omr_student_id :bigint(8)
#  omr_test_id    :bigint(8)
#
# Indexes
#
#  index_omr_student_tests_on_omr_student_id  (omr_student_id)
#  index_omr_student_tests_on_omr_test_id     (omr_test_id)
#

require 'test_helper'

class Omr::StudentTestTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
