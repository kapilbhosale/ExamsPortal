# == Schema Information
#
# Table name: exams
#
#  id                  :bigint(8)        not null, primary key
#  description         :text
#  exam_available_till :datetime
#  exam_type           :integer          default("jee")
#  is_pr_generated     :boolean          default(FALSE)
#  name                :string           not null
#  negative_marks      :integer          default(-1), not null
#  no_of_questions     :integer
#  positive_marks      :integer          default(4), not null
#  publish_result      :boolean          default(FALSE), not null
#  published           :boolean
#  show_exam_at        :datetime
#  show_result_at      :datetime
#  time_in_minutes     :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  org_id              :integer          default(0)
#
# Indexes
#
#  index_exams_on_name    (name)
#  index_exams_on_org_id  (org_id)
#

require 'test_helper'

class ExamTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
