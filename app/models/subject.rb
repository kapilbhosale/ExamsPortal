# == Schema Information
#
# Table name: subjects
#
#  id         :bigint(8)        not null, primary key
#  name       :string           not null
#  name_map   :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_subjects_on_name_map  (name_map)
#

class Subject < ApplicationRecord
  before_create :add_name_map

  has_many :sections, dependent: :destroy

  private
  def add_name_map
    self.name_map = self.name_map || self.name.to_s.downcase.gsub(' ', '_')
  end
end
