# == Schema Information
#
# Table name: video_lectures
#
#  id                 :bigint(8)        not null, primary key
#  by                 :string
#  description        :string
#  enabled            :boolean          default(TRUE)
#  subject_name       :integer
#  tag                :string
#  thumbnail          :string
#  title              :string
#  uploaded_thumbnail :string
#  url                :string
#  video_type         :integer          default("vimeo")
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  genre_id           :integer          default(0)
#  laptop_vimeo_id    :integer
#  org_id             :integer          default(0)
#  subject_id         :integer
#  video_id           :string
#
# Indexes
#
#  index_video_lectures_on_subject_id  (subject_id)
#

class VideoLecture < ApplicationRecord
  # validates :thumbnail, presence: true
  validates :title, presence: true
  validates :subject_name, presence: true

  enum subject_name: { chem: 0, phy: 1, bio: 2, maths: 3, other: 4,
    english: 5, econonics: 6, 'bk & a/c': 7,  's.p': 8, 'o.c.m.': 9, 'maths(com)': 10,
    'current affairs': 11, 'gs&gk': 12, marathi: 13, math: 14, 'eng': 15,
    reasoning: 16,
    default: 100,
  }

  enum video_type: { vimeo: 0, youtube: 1 }

  has_many :batch_video_lectures
  has_many :batches, through: :batch_video_lectures

  belongs_to :subject
  belongs_to :org
  belongs_to :genre, optional: true
  mount_uploader :uploaded_thumbnail, PhotoUploader
  # after_create :send_push_notifications

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

  def send_push_notifications
    fcm = FCM.new(org.fcm_server_key)
    batches.each do |batch|
      reg_ids = batch.students.where.not(fcm_token: nil).pluck(:fcm_token)
      fcm.send(reg_ids, push_options)
    end
  end

  def push_options
    {
      priority: 'high',
      data: {
        message: 'New Video Lecture Added'
      },
      notification: {
        body: "New Video of subject #{subject.name}, Name: #{title}, Please visit and take a look. Study Hard.",
        title: "New Video of subject #{subject.name} Added - '#{title}'",
        image: org.data['push_image']
      }
    }
  end
end

