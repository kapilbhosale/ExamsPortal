# == Schema Information
#
# Table name: genres
#
#  id                   :bigint(8)        not null, primary key
#  hidden               :boolean          default(FALSE)
#  name                 :string
#  video_lectures_count :integer          default(0)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  org_id               :integer
#  subject_id           :integer
#

class Genre < ApplicationRecord
  has_many :video_lectures
end
