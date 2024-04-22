# == Schema Information
#
# Table name: omr_student_tests
#
#  id             :bigint(8)        not null, primary key
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
# Foreign Keys
#
#  fk_rails_...  (omr_student_id => omr_students.id)
#  fk_rails_...  (omr_test_id => omr_tests.id)
#

class Omr::StudentTest < ApplicationRecord
  belongs_to :omr_student, class_name: 'Omr::Student'
  belongs_to :omr_test, class_name: 'Omr::Test'
end
