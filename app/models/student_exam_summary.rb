# == Schema Information
#
# Table name: student_exam_summaries
#
#  id              :bigint(8)        not null, primary key
#  answered        :integer
#  correct         :integer
#  incorrect       :integer
#  no_of_questions :integer
#  not_answered    :integer
#  score           :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  section_id      :bigint(8)
#  student_exam_id :bigint(8)
#
# Indexes
#
#  index_student_exam_summaries_on_section_id       (section_id)
#  index_student_exam_summaries_on_student_exam_id  (student_exam_id)
#

class StudentExamSummary < ApplicationRecord
  belongs_to :section
  belongs_to :student_exam

  validates :student_exam_id, uniqueness: true
end
