# frozen_string_literal: true

json.array! @transactions do |transaction|
  json.id transaction.id
  json.receipt_number transaction.receipt_number
  json.date transaction.created_at.strftime("%d-%b-%Y %I:%M%p")
  json.paid_amount transaction.paid_amount
  json.discount transaction.discount_amount
  json.remaining_amount transaction.remaining_amount
  json.next_due_date transaction.next_due_date
  json.mode_of_payment transaction.mode
end
