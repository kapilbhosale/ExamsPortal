# == Schema Information
#
# Table name: exams
#
#  id              :bigint(8)        not null, primary key
#  description     :text
#  name            :string           not null
#  no_of_questions :integer
#  publish_result  :boolean          default(FALSE), not null
#  published       :boolean
#  time_in_minutes :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_exams_on_name  (name)
#

require 'test_helper'

class ExamTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
