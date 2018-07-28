# == Schema Information
#
# Table name: practice_questions
#
#  id          :bigint(8)        not null, primary key
#  hash        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  question_id :bigint(8)
#  topic_id    :bigint(8)
#
# Indexes
#
#  index_practice_questions_on_hash         (hash)
#  index_practice_questions_on_question_id  (question_id)
#  index_practice_questions_on_topic_id     (topic_id)
#

require 'test_helper'

class PracticeQuestionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
