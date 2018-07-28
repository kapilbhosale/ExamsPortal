# == Schema Information
#
# Table name: questions
#
#  id               :bigint(8)        not null, primary key
#  difficulty_level :integer          default("default"), not null
#  explanation      :text
#  title            :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
