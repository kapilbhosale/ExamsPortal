# == Schema Information
#
# Table name: student_question_answers
#
#  id          :bigint(8)        not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  option_id   :bigint(8)
#  question_id :bigint(8)
#  student_id  :bigint(8)
#
# Indexes
#
#  index_student_question_answers_on_option_id    (option_id)
#  index_student_question_answers_on_question_id  (question_id)
#  index_student_question_answers_on_student_id   (student_id)
#

class StudentQuestionAnswer < ApplicationRecord
end
