# == Schema Information
#
# Table name: genres
#
#  id         :bigint(8)        not null, primary key
#  hidden     :boolean          default(FALSE)
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  org_id     :integer
#

class Genre < ApplicationRecord
  has_many :video_lectures
  belongs_to :org
  belongs_to :subject, optional: true
end
# Genre.reset_counters(g.id, :video_lectures)
