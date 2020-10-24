class NotificationWorker
  include Sidekiq::Worker
  def perform
    VideoLecture.where('publish_at > ?', Time.current - 10.minutes).where('publish_at <= ?', Time.current).each do |vl|
      puts "Video Notification CRON ===========> #{vl.id}"
      vl.send_push_notifications
    end
  end
end

Sidekiq::Cron::Job.create(name: 'Notification worker - every 10 min', cron: '*/10 * * * *', class: 'NotificationWorker')
# execute at every 5 minutes, ex: 12:05, 12:10, 12:15...etc
# => true