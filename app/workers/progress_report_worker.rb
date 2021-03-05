class ProgressReportWorker
  include Sidekiq::Worker
  def perform
    Exam.where(is_pr_generated: false).each do |exam|
      exam.prepare_report
      exam.is_pr_generated = true
      exam.save
    end
  end
end

Sidekiq::Cron::Job.create(name: 'ProgressReportWorker worker - every night 2 am', cron: '0 2 * * *', class: 'ProgressReportWorker')
