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
    _total_marks = REDIS_CACHE&.get("exam-section-total-marks-#{id}")
    return _total_marks.to_i if _total_marks.present?

    if exam.neet?
      _total_marks = 45 * 4
    elsif exam.jee_advance?
      _total_marks = jee_advance_total_marks
    elsif exam.jee_paper_1?
      _total_marks = jee_paper_1_total_marks
    elsif exam.jee_paper_2?
      _total_marks = jee_paper_2_total_marks
    else
      _total_marks = regular_total_marks
    end

    REDIS_CACHE&.set("exam-section-total-marks-#{id}", _total_marks)
    _total_marks.to_i
  end

  def jee_advance_total_marks
    without_multi_count = exam.questions.where(section_id: section_id).where.not(question_type: Question.question_types[:multi_select]).count
    total = (positive_marks || 1) * without_multi_count
    total += (exam.questions.where(section_id: section_id).multi_select.count * 4)
    # if there are 10 input questions, considering 5 of them are optional.
    total -= 5 * 4 if input_count == 10
    total
  end

  def jee_paper_1_total_marks
    66
  end

  def jee_paper_2_total_marks
    60
  end

  def regular_total_marks
    total = (positive_marks || 1) * exam.questions.where(section_id: section_id).count
    # if there are 10 input questions, considering 5 of them are optional.
    total -= 5 * 4 if input_count == 10
    total
  end

  def multi_count
    exam.questions.where(section_id: section_id).multi_select.count
  end

  def input_count
    exam.questions.where(section_id: section_id).input.count
  end
end
