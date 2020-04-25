# frozen_string_literal: true

class Api::V1::VideosController < Api::V1::ApiController

  def index
    lectures = VideoLecture.includes(:batches)
      .where(batches: {id: current_student.batches})
      .where(enabled: true)
      .order(id: :desc)

    lectures_data = {}
    lectures.each do |lect|
      lect_data = lect.attributes.slice("id" ,"title", "url", "video_id", "description", "by", "tag", "subject")
      banner_url = lect.thumbnail.banner.url
      if banner_url.include?('amazonaws.com')
        video_name = banner_url.split('/').last
        lect_data['thumbnail_url'] = "https://smart-exams-production.s3.ap-south-1.amazonaws.com/video-thumbnails/#{video_name}"
      else
        lect_data['thumbnail_url'] = "#{helpers.full_domain_path}#{banner_url}"
      end
      lect_data['added_ago'] = helpers.time_ago_in_words(lect.created_at)
      lectures_data[lect.subject] ||= []
      lectures_data[lect.subject] << lect_data
    end
    json_data = {
      chem: lectures_data['chem'],
      phy: lectures_data['phy'],
      bio: lectures_data['bio'],
      maths: lectures_data['maths']
    }
    render json: json_data, status: :ok
  end
end
