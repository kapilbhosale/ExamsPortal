class DeleteExamError < StandardError; end

module Exams
  class DeleteExamService
    attr_reader :exam
    def initialize(exam_id)
      @exam = Exam.find_by(id: exam_id)
    end

    def delete
      validate_request
      exam.destroy!
      return {status: true, message: 'Exam deleted successfully'}
    rescue DeleteExamError, ActiveRecord::RecordInvalid => ex
      return {status: false, message: ex.message}
    end

    private

    def validate_request
      raise DeleteExamError, 'Exam does not exists!' if exam.nil?
      # raise DeleteExamError, 'Exam can\'t be deleted because some students have already appeared for it!' if students_appeared?
    end

    def students_appeared?
      StudentExam.where(exam_id: exam.id).exists?
    end
  end
end
