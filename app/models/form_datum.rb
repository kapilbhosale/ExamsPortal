# == Schema Information
#
# Table name: form_data
#
#  id         :bigint(8)        not null, primary key
#  data       :jsonb
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  form_id    :string
#  student_id :bigint(8)
#
# Indexes
#
#  index_form_data_on_student_id  (student_id)
#

class FormDatum < ApplicationRecord
  belongs_to :student
end
