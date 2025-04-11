# frozen_string_literal: true

json.array! @notes do |note|
  json.id note.id
  json.name note.name
  json.min_pay note.min_pay.present? ? note.min_pay.split(" ").first.to_i : 100
end
