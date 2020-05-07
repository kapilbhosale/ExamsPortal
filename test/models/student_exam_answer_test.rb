# == Schema Information
#
# Table name: student_exam_answers
#
#  id              :bigint(8)        not null, primary key
#  ans             :string
#  question_props  :jsonb
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  option_id       :bigint(8)
#  question_id     :bigint(8)
#  student_exam_id :bigint(8)
#
# Indexes
#
#  index_student_exam_answers_on_option_id                        (option_id)
#  index_student_exam_answers_on_question_id                      (question_id)
#  index_student_exam_answers_on_student_exam_id                  (student_exam_id)
#  index_student_exam_answers_on_student_exam_id_and_question_id  (student_exam_id,question_id) UNIQUE
#

require 'test_helper'

class StudentExamAnswerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
