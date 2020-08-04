class SyncWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'critical', retry: 2

  def perform(student_id, exam_id, questions_data, end_exam_sync = false)
    ses = StudentExamSync.find_by(student_id: student_id, exam_id: exam_id)
    if ses.present?
      ses.sync_data = questions_data
      ses.end_exam_sync = end_exam_sync
      ses.save
    else
      StudentExamSync.create(
        student_id: student_id,
        exam_id: exam_id,
        sync_data: questions_data,
        end_exam_sync: end_exam_sync
      )
    end
  end
end
