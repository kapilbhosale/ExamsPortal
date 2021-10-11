# frozen_string_literal: true

class VideoLinkFetchWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'critical', retry: 2

  def perform(lecture_id)
    lecture = VideoLecture.find_by(id: lecture_id)
    lecture.update_play_url if lecture.present?
  end
end
