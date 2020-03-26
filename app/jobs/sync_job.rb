class SyncJob
  include SuckerPunch::Job
  def perform(student_id, exam_id, questions_data)
    ses = StudentExamSync.find_by(student_id: student_id, exam_id: exam_id)
    if ses.present?
      ses.sync_data = questions_data
      ses.save
    else
      StudentExamSync.create(
        student_id: student_id,
        exam_id: exam_id,
        sync_data: questions_data
      )
    end
  end
end
# Students::SyncService.new(student_id, exam_id, questions_data).call