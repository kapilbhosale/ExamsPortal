class ProgressReportWorker
  include Sidekiq::Worker
  def perform(exam_id)
    exam = Exam.find_by(id: exam_id)
    if exam.present?
      exam.prepare_report
    else
      Exam.where('creadte_at > ?', Time.now - 30.days).where(is_pr_generated: false).each do |exam|
        exam.prepare_report
      end
    end
  end
end

Sidekiq::Cron::Job.create(name: 'ProgressReportWorker worker - every night 2 am', cron: '0 2 * * *', class: 'ProgressReportWorker')
