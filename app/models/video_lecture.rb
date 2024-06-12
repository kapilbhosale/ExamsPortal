# == Schema Information
#
# Table name: video_lectures
#
#  id                   :bigint(8)        not null, primary key
#  by                   :string
#  description          :string
#  enabled              :boolean          default(TRUE)
#  hide_at              :datetime
#  link_udpated_at      :datetime
#  play_url_from_server :string
#  publish_at           :datetime
#  subject_name         :integer
#  tag                  :string
#  thumbnail            :string
#  title                :string
#  tp_streams_data      :jsonb
#  uploaded_thumbnail   :string
#  url                  :string
#  video_type           :integer          default("vimeo")
#  view_limit           :integer          default(3)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  genre_id             :integer          default(0)
#  laptop_vimeo_id      :integer
#  org_id               :integer          default(0)
#  subject_id           :integer
#  tp_streams_id        :string
#  video_id             :string
#  yt_video_id          :string
#
# Indexes
#
#  index_video_lectures_on_genre_id    (genre_id)
#  index_video_lectures_on_org_id      (org_id)
#  index_video_lectures_on_subject_id  (subject_id)
#

class VideoLecture < ApplicationRecord
  require 'carrierwave/orm/activerecord'
  acts_as_paranoid
  # validates :thumbnail, presence: true
  validates :title, presence: true
  validates :subject_name, presence: true

  TP_STREAM_ORG_ID = 'tknatp'

  enum subject_name: { chem: 0, phy: 1, bio: 2, maths: 3, other: 4,
    english: 5, econonics: 6, 'bk & a/c': 7,  's.p': 8, 'o.c.m.': 9, 'maths(com)': 10,
    'current affairs': 11, 'gs&gk': 12, marathi: 13, math: 14, 'eng': 15,
    reasoning: 16,
    default: 100,
  }

  enum video_type: { vimeo: 0, youtube: 1 }

  has_many :batch_video_lectures
  has_many :batches, through: :batch_video_lectures
  has_many :messages, as: :messageable

  belongs_to :subject
  belongs_to :org
  belongs_to :genre, optional: true, counter_cache: true
  mount_uploader :uploaded_thumbnail, PhotoUploader
  # after_create :send_push_notifications

  after_save :flush_video_folders_cache
  after_save :flush_videos_cache
  after_save :update_tp_stream_details

  def self.latest_videos(student, domain="", build_number)
    VideoLecture
      .includes(:batches, :subject)
      .where(batches: {id: student.batches})
      .where(org_id: student.org_id)
      .where(enabled: true)
      .where('publish_at <= ?', Time.current)
      .where('hide_at IS NULL or hide_at >= ?', Time.current)
      .order(created_at: :desc).limit(3).map do |lect|
        lect_data = lect.attributes.slice("id" ,"title", "url", "video_id", "description", "by", "tag", "subject_id", "video_type", "play_url_from_server", "tp_streams_id")
        lect_data['thumbnail_url'] = lect.vimeo? ? lect.thumbnail : lect.uploaded_thumbnail.url
        lect_data['added_ago'] = (lect.publish_at || lect.created_at).strftime("%d-%B-%Y %I:%M%p")
        if lect.vimeo?
          lect_data['play_url'] = "#{domain}/students/lectures/#{lect.video_id}"
        else
          lect_data['play_url'] = lect.url
        end

        lect_data['player'] = {
          use_first: student.org&.data.dig('player', 'use_first'), #'custom|tp_streams'
          on_error: (build_number >= 87 ? 'youtube' : nil)
        }

        lect_data['play_url_from_server'] = nil if lect.play_url_expired?
        lect_data
    end
  end

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

  def update_play_url
    video_data = `yt-dlp --get-url --format 18/22 '#{url}' --proxy #{Proxy.random}`
    if video_data.blank?
      yt_dlp_errors = REDIS_CACHE.get('yt-dlp-errors') || '{}'
      yt_dlp_errors = JSON.parse(yt_dlp_errors)
      yt_dlp_errors[id] = Time.current.strftime('%d-%b-%Y %I:%M%p')
      REDIS_CACHE.set('yt-dlp-errors', yt_dlp_errors.to_json)
      return
    end

    self.play_url_from_server = video_data.squish
    self.link_udpated_at = Time.current
    save
  end

  def play_url_live?
    expired = play_url_expired?
    !expired
  end

  def play_url_expired?
    return true if play_url_from_server.blank?

    expiry_time = nil
    duration_seconds = nil

    expiry_data = play_url_from_server.match(/expire=[\d]+/)
    expiry_time = expiry_data.to_s.split('=').last&.to_i if expiry_data.present?

    duration_data = play_url_from_server.match(/dur=[\d]+/)
    duration_seconds = duration_data.to_s.split('=').last&.to_i if duration_data.present?

    if expiry_time.present? && duration_seconds.present?
      video_expiry_time = expiry_time - (duration_seconds + 30.minutes.to_i)
      return Time.current.to_i >= video_expiry_time
    end
    link_udpated_at <= (Time.current - 1.hour)
  end

  def send_push_notifications
    fcm = FCM.new(org.fcm_server_key)
    batches.each do |batch|
      batch.students.where.not(fcm_token: nil).pluck(:fcm_token).each_slice(500) do |reg_ids|
        fcm.send(reg_ids, push_options)
      end
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

  def flush_video_folders_cache
    REDIS_CACHE&.keys('VF-*').each do |cache_key|
      REDIS_CACHE&.del(cache_key)
    end
  end

  def flush_videos_cache
    REDIS_CACHE&.keys('CV-*').each do |cache_key|
      REDIS_CACHE&.del(cache_key)
    end
  end

  def tp_streams_json
    {
      id: tp_streams_data["id"],
      title: tp_streams_data["title"],
      dash_url: tp_streams_data.dig("video", "dash_url"),
      playback_url: tp_streams_data.dig("video", "playback_url"),
    }
  end

  def update_tp_stream_details
    if need_tp_streams_update?
      url = "https://app.tpstreams.com/api/v1/#{TP_STREAM_ORG_ID}/assets/#{tp_streams_id}/"
      resp = Faraday.get(url) do |req|
        req.headers['Content-Type'] = 'application/json'
        req.headers['Authorization'] = "Token #{ENV.fetch('TP_STREAMS_TOKEN')}"
      end
      if resp.status == 200
        self.update(tp_streams_data: JSON.parse(resp.body))
      end
    end
  end

  def need_tp_streams_update?
    tp_streams_id.present? && (tp_streams_data.blank? || tp_streams_data["id"] != tp_streams_id)
  end
end
