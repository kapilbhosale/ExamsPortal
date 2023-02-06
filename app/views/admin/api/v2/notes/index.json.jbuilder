# frozen_string_literal: true

json.array! @notes do |note|
  json.id note.id
  json.name note.name
end
