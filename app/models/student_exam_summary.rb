# == Schema Information
#
# Table name: student_exam_summaries
#
#  id                        :bigint(8)        not null, primary key
#  answered                  :integer
#  correct                   :integer
#  correct_input_questions   :integer          default(0)
#  extra_data                :jsonb
#  incorrect                 :integer
#  incorrect_input_questions :integer          default(0)
#  input_questions_present   :boolean          default(FALSE)
#  no_of_questions           :integer
#  not_answered              :integer
#  score                     :integer
#  total_score               :integer          default(0)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  section_id                :bigint(8)
#  student_exam_id           :bigint(8)
#
# Indexes
#
#  index_student_exam_summaries_on_section_id                      (section_id)
#  index_student_exam_summaries_on_student_exam_id                 (student_exam_id)
#  index_student_exam_summaries_on_student_exam_id_and_section_id  (student_exam_id,section_id) UNIQUE
#

class StudentExamSummary < ApplicationRecord
  belongs_to :section
  belongs_to :student_exam

  validates :student_exam_id, uniqueness: { scope: :section_id }
end
