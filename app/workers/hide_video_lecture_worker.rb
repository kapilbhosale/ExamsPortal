class HideVideoLectureWorker
  include Sidekiq::Worker
  def perform
    VideoLecture.where.not(hide_at: nil).where(enabled: true).where('hide_at <= ?', Time.current).update_all(enabled: false)
  end
end

Sidekiq::Cron::Job.create(name: 'Video Hide worker - every 1 hr', cron: '0 * * * *', class: 'HideVideoLectureWorker')
# execute at every 5 minutes, ex: 12:05, 12:10, 12:15...etc
# => true