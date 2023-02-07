json.array! @student_notes do |student_note|
  json.id student_note.id
  json.student_id student_note.student_id
  json.name student_note.note.name
  json.created_at student_note.created_at.strftime("%d-%B-%Y %I:%M%p")
end