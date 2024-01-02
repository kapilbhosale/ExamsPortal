# == Schema Information
#
# Table name: course_change_entries
#
#  id             :bigint(8)        not null, primary key
#  fees_paid_data :jsonb            not null
#  pending_amount :float            not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  new_batch_id   :integer          not null
#  old_batch_id   :integer          not null
#  student_id     :bigint(8)
#
# Indexes
#
#  index_course_change_entries_on_student_id  (student_id)
#

require 'test_helper'

class CourseChangeEntryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
