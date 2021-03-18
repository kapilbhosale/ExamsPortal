# == Schema Information
#
# Table name: questions
#
#  id               :bigint(8)        not null, primary key
#  difficulty_level :integer          default("default"), not null
#  explanation      :text
#  is_image         :boolean          default(FALSE)
#  question_type    :integer          default("single_select")
#  title            :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  section_id       :integer          default(1)
#
# Indexes
#
#  index_questions_on_section_id  (section_id)
#

require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
