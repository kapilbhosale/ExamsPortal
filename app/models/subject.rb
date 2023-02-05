# == Schema Information
#
# Table name: subjects
#
#  id         :bigint(8)        not null, primary key
#  klass      :string
#  name       :string           not null
#  name_map   :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  org_id     :integer
#
# Indexes
#
#  index_subjects_on_name_map  (name_map)
#  index_subjects_on_org_id    (org_id)
#

class Subject < ApplicationRecord
  before_create :add_name_map
  belongs_to :org
  has_many :video_lectures
  has_many :genres

  KLASSES = {
    '11th': '11th Standard',
    '12th': '11th Standard',
    'repeater': 'Repeater'
  }.freeze

  NAME_REGEX = /\A[a-zA-Z0-9 \.\(\)]+\z/
  validates :name, uniqueness: { scope: :org_id }
  validates :name, format: { with: NAME_REGEX, message: 'No special Characters allowed in name.'}

  private
  def add_name_map
    self.name_map = self.name_map || self.name.to_s.downcase.gsub(' ', '_')
  end
end
