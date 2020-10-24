# == Schema Information
#
# Table name: trackers
#
#  id            :bigint(8)        not null, primary key
#  data          :jsonb
#  event         :string
#  resource_type :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  resource_id   :integer
#  student_id    :bigint(8)
#
# Indexes
#
#  index_trackers_on_student_id  (student_id)
#

class Tracker < ApplicationRecord
end
