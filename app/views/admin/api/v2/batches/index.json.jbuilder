# frozen_string_literal: true

json.array! @batches do |batch|
  json.id batch.id
  json.name batch.name
  json.group_id batch.batch_group.id
  json.group_name batch.batch_group.name
  json.klass batch.klass || 'Default'
end
