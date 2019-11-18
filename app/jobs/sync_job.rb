class SyncJob
  include SuckerPunch::Job
  workers 8

  def perform(student_id, exam_id, questions_data)
    puts "-----------------"
    puts "-----------------"

    puts "-----------------"

    puts "-----------------"
    puts "-----------------"
    puts "-----------------"

    puts "-----------------"
    Students::SyncService.new(student_id, exam_id, questions_data).call
  end
end