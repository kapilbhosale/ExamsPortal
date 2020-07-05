# == Schema Information
#
# Table name: genres
#
#  id         :bigint(8)        not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  org_id     :integer
#

class Genre < ApplicationRecord
  has_many :video_lectures
end
