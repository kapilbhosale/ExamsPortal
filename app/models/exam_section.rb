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
end
