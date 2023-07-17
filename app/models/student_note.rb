# == Schema Information
#
# Table name: student_notes
#
#  id         :bigint(8)        not null, primary key
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

class StudentNote < ApplicationRecord
  belongs_to :student
  belongs_to :note

  def batches
    student&.batches&.pluck(:name)
  end
end
