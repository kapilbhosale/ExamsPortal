json.student do
  json.id @student.id
  json.student_id @student.id
  json.roll_number @student.roll_number
  json.name @student.name
  json.parent_mobile_number @student.parent_mobile
  json.batches @student.batches.pluck(:name)
  json.pending_amount @pending_amount
  json.remark @message
end