# == Schema Information
#
# Table name: student_exams
#
#  id         :bigint(8)        not null, primary key
#  ended_at   :datetime
#  started_at :datetime         not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  exam_id    :bigint(8)
#  student_id :bigint(8)
#
# Indexes
#
#  index_student_exams_on_exam_id     (exam_id)
#  index_student_exams_on_student_id  (student_id)
#

class StudentExam < ApplicationRecord
  belongs_to  :student
  belongs_to  :exam
  has_many :student_exam_answers

  def correct_answers_count
  	student_exam_answers.select do |sea|
  		sea.option.is_answer
  	end.size
	end
end
