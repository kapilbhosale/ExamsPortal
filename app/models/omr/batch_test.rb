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
#  index_omr_batch_tests_on_omr_batch_id  (omr_batch_id)
#  index_omr_batch_tests_on_omr_test_id   (omr_test_id)
#

class Omr::BatchTest < ApplicationRecord
  belongs_to :omr_test, class_name: 'Omr::Test'
  belongs_to :omr_batch, class_name: 'Omr::Batch'

  validates :omr_test_id, uniqueness: { scope: :omr_batch_id }
end
