class MorningStudyNotifWorker
  include Sidekiq::Worker
  def perform
    # Org.all.each do |org|
    #   org.send_push_notifications
    # end
  end
end

# Sidekiq::Cron::Job.create(name: 'MorningStudyNotifWorker - every day 9 AM', cron: '0 9 * * 1', class: 'MorningStudyNotifWorker')
