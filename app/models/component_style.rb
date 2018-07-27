# == Schema Information
#
# Table name: component_styles
#
#  id             :bigint(8)        not null, primary key
#  component_type :string
#  style          :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  component_id   :bigint(8)
#
# Indexes
#
#  index_component_styles_on_component_type_and_component_id  (component_type,component_id)
#

class ComponentStyle < ApplicationRecord
end
