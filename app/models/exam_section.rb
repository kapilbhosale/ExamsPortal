# == Schema Information
#
# Table name: exam_sections
#
#  id             :bigint(8)        not null, primary key
#  negative_marks :integer          default(-1), not null
#  positive_marks :integer          default(4), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  exam_id        :bigint(8)
#  section_id     :bigint(8)
#
# Indexes
#
#  index_exam_sections_on_exam_id     (exam_id)
#  index_exam_sections_on_section_id  (section_id)
#

class ExamSection < ApplicationRecord
  belongs_to :exam
  belongs_to :section

  def total_marks
    exam.jee_advance? ? jee_advance_total_marks : regular_total_marks
  end

  def jee_advance_total_marks
    without_multi_count = exam.questions.where(section_id: section_id).where.not(question_type: Question.question_types[:multi_select]).count
    total = (positive_marks || 1) * without_multi_count
    total + (exam.questions.where(section_id: section_id).multi_select.count * 4)
  end

  def regular_total_marks
    ( positive_marks || 1 ) * exam.questions.where(section_id: section_id).count
  end

  def multi_count
    exam.questions.where(section_id: section_id).multi_select.count
  end

  def input_count
    exam.questions.where(section_id: section_id).input.count
  end
end
