class SyncJob
  include SuckerPunch::Job
  def perform(student_id, exam_id, questions_data)
    Students::SyncService.new(student_id, exam_id, questions_data).call
  end
end