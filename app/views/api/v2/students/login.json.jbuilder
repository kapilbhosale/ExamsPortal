# frozen_string_literal: true

json.student do
  json.id @student.id
  json.student_id @student.id
  json.roll_number @student.roll_number
  json.name @student.name
  json.parent_mobile_number @student.parent_mobile
  json.api_key @student.api_key
  json.fcm_token @student.fcm_token
  json.vimeo_access_token @student.org&.vimeo_access_token
  json.exam_portal_link @exam_portal_link
  json.batches @student.batches.pluck(:name)
end

json.otp (@otp || '111111')
