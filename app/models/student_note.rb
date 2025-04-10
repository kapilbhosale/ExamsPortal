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

class StudentNote < ApplicationRecord
  belongs_to :student
  belongs_to :note

  def batches
    student&.batches&.pluck(:name)
  end
end


# require 'csv'
# file = "#{Rails.root}/public/student_notes.csv"
# student_notes = StudentNote.includes(:note, student: [:batches]).all
# headers = ['Id', 'notes', 'Student Name', 'Roll Number', 'Parent Mobile', 'Batches', 'Date']
# CSV.open(file, 'w', write_headers: true, headers: headers) do |writer|
#   student_notes.each do |sn|
#     writer << [
#       sn.id,
#       sn.note.name,
#       sn.student.name,
#       sn.student.roll_number,
#       sn.student.parent_mobile,
#       sn.student.batches.pluck(:name).join(' | '),
#       sn.created_at.strftime("%d-%b-%y %I:%M%p")
#     ]
#     putc "."
#   end
# end
