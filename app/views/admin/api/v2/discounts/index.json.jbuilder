# frozen_string_literal: true

json.array! @discounts do |discount|
  json.id discount.id
  json.name discount.student_name
  json.roll_number discount.roll_number
  json.parent_mobile discount.parent_mobile
  json.amount discount.amount
  json.approved_by discount.approved_by
  json.comment discount.comment
  json.set_discount_percent discount.data['discount_percent']
  json.set_discount_amount discount.data['discount_amount']
  json.collect_amount discount.data['amount_to_pay']
  json.type discount.type_of_discount
end
