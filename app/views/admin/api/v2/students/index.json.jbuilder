json.array! @students do |student|
  json.id student.id
  json.roll_number student.roll_number
  json.name student.name
  json.parent_mobile student.parent_mobile
  json.batches student.batches.joins(:fees_templates).pluck(:name).join(', ')
end
