# frozen_string_literal: true

module AdminModule
  class VimeoThumbnailFetcher
    attr_reader :video_lecture, :org
    DEFAULT_IMAGE_URL = ""
    def initialize(video_lecture_id, org_id)
      @video_lecture = VideoLecture.find_by(id: video_lecture_id)
      @org = Org.find_by(id: org_id)
    end

    def call
      return false if org.blank? || video_lecture.blank?

      video_lecture.thumbnail = video_url
      video_lecture.save
    end

    def video_url
      url = "https://api.vimeo.com/videos/#{video_lecture.video_id}"
      resp = Faraday.get(url) do |req|
        req.headers['Content-Type'] = 'application/json'
        req.headers['Authorization'] = "bearer #{org.vimeo_access_token}"
      end

      thumbnail_url = nil

      if resp.status == 200
        json_response = JSON.parse(resp.body)
        json_response.dig('pictures', 'sizes').each do |val|
          thumbnail_url = val['link'] if val['width'] == 640
        end
      end

      thumbnail_url || DEFAULT_IMAGE_URL
    end
  end
end
