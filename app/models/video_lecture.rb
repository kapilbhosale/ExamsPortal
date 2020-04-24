# == Schema Information
#
# Table name: video_lectures
#
#  id          :bigint(8)        not null, primary key
#  by          :string
#  description :string
#  enabled     :boolean          default(TRUE)
#  subject     :integer
#  tag         :string
#  thumbnail   :string
#  title       :string
#  url         :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  video_id    :string
#

class VideoLecture < ApplicationRecord
  enum subject: { chem: 0, phy: 1, bio: 2, maths: 3, other: 4 }

  has_many :batch_video_lectures
  has_many :batches, through: :batch_video_lectures

  mount_uploader :thumbnail, PhotoUploader
end

