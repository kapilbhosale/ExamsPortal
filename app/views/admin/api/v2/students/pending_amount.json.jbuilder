json.student do
  json.id @student.id
  json.student_id @student.id
  json.roll_number @student.roll_number
  json.name @student.name
  json.parent_mobile_number @student.parent_mobile
  json.batches @student.batches.joins(:fees_templates).pluck(:name).join(', ')
  json.pending_amount @pending_amount
  json.paid_percent @paid_percent
  json.remark @message
end