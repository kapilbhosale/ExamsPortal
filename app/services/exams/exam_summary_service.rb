class ExamSummaryError < StandardError; end
module Exams
  class ExamSummaryService
    attr_reader :params,:exam, :student
    def initialize(params, student)
      @params = params
      @exam = Exam.find_by(id: params[:exam_id])
      @student = student
    end

    def process_summary
      validate_request
      @student_exam = StudentExam.find_by(student_id: student.id, exam_id: exam.id)
      return {status: true, message:'', exam: exam, student_exam: @student_exam}
    rescue ExamSummaryError, ActiveRecord::RecordInvalid => ex
      return {status: false, message: ex.message}
    end

    private

    def validate_request
      raise ExamSummaryError, 'Exam does not exists.' if exam.nil?
      raise ExamSummaryError, 'Student does not exists' if student.nil?
      raise ExamSummaryError, 'Result is withhold for this exam. Will be published later.' unless exam.publish_result
    end
  end
end
