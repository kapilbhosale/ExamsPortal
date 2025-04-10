# == Schema Information
#
# Table name: student_notes
#
#  id         :bigint(8)        not null, primary key
#  comment    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  note_id    :bigint(8)
#  org_id     :bigint(8)
#  student_id :bigint(8)
#
# Indexes
#
#  index_student_notes_on_note_id     (note_id)
#  index_student_notes_on_org_id      (org_id)
#  index_student_notes_on_student_id  (student_id)
#

require 'test_helper'

class StudentNoteTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
