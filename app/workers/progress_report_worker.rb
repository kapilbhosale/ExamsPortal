class ProgressReportWorker
  include Sidekiq::Worker
  def perform
    Exam.where('creadte_at > ?', Time.now - 30.days).where(is_pr_generated: false).each do |exam|
      exam.prepare_report
    end
  end
end

Sidekiq::Cron::Job.create(name: 'ProgressReportWorker worker - every night 2 am', cron: '0 2 * * *', class: 'ProgressReportWorker')
