# == Schema Information
#
# Table name: exam_questions
#
#  id          :bigint(8)        not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  exam_id     :bigint(8)
#  question_id :bigint(8)
#
# Indexes
#
#  index_exam_questions_on_exam_id      (exam_id)
#  index_exam_questions_on_question_id  (question_id)
#

class ExamQuestion < ApplicationRecord
  belongs_to :exam
  belongs_to :question
end
