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
#  video_type  :integer          default("vimeo")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  video_id    :string
#

class VideoLecture < ApplicationRecord
  validates :thumbnail, presence: true
  validates :title, presence: true
  validates :subject, presence: true

  enum subject: { chem: 0, phy: 1, bio: 2, maths: 3, other: 4 }
  enum video_type: { vimeo: 0, youtube: 1 }

  has_many :batch_video_lectures
  has_many :batches, through: :batch_video_lectures

  # mount_uploader :thumbnail, PhotoUploader

  def set_thumbnail
    require 'net/http'
    require 'uri'
    require 'json'

    uri = URI.parse(get_uri)
    header = {'Content-Type' => 'application/json'}

    post_data = {
      token: "SmartClassApp@t0k3N@!@#",
      student: {
        name: student.name,
        roll_number: student.roll_number,
        parent_mobile_number: student.parent_mobile
      },
      batch_name: batch_name
    }

    # Create the HTTP objects
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri, header)
    request.body = post_data.to_json

    # Send the request
    response = http.request(request)
    if response.code == "200"
      puts "\n\n\n\n\n\n Synced successfully .. ! #{post_data}"
    else
      puts "\n\n\n\n\n\n $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
      puts " FAILED #{post_data}"
      puts "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
    end
  end
end

