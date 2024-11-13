# == Schema Information
#
# Table name: omr_batch_tests
#
#  id           :bigint(8)        not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  omr_batch_id :bigint(8)
#  omr_test_id  :bigint(8)
#
# Indexes
#
#  index_omr_batch_tests_on_omr_batch_id                  (omr_batch_id)
#  index_omr_batch_tests_on_omr_test_id                   (omr_test_id)
#  index_omr_batch_tests_on_omr_test_id_and_omr_batch_id  (omr_test_id,omr_batch_id) UNIQUE
#

require 'test_helper'

class Omr::BatchTestTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
