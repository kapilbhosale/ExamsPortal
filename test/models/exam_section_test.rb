# == Schema Information
#
# Table name: exam_sections
#
#  id         :bigint(8)        not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  exam_id    :bigint(8)
#  section_id :bigint(8)
#
# Indexes
#
#  index_exam_sections_on_exam_id     (exam_id)
#  index_exam_sections_on_section_id  (section_id)
#

require 'test_helper'

class ExamSectionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
