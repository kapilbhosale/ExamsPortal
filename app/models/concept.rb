# == Schema Information
#
# Table name: concepts
#
#  id         :bigint(8)        not null, primary key
#  name       :string           not null
#  name_map   :string           not null
#  weightage  :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  subject_id :bigint(8)
#
# Indexes
#
#  index_concepts_on_name_map    (name_map)
#  index_concepts_on_subject_id  (subject_id)
#

class Concept < ApplicationRecord
  before_create :add_name_map

  belongs_to :subject
  has_many :topics, dependent: :destroy

  private
  def add_name_map
    self.name_map = self.name_map || self.name.to_s.downcase.gsub(' ', '_')
  end
end
