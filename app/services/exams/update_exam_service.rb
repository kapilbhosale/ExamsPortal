class UpdateExamError < StandardError; end

module Exams
  class UpdateExamService
    attr_reader :exam_params, :exam
    def initialize(exam_params)
      @exam_params = exam_params
      @exam = Exam.find_by(id: exam_params[:id])
    end

    def update
      validate_request
      exam.update!({publish_result: exam_params[:exam][:publish_result]})
      return {status: true, message: 'Exam details updated successfully'}
    rescue UpdateExamError, ActiveRecord::RecordInvalid => ex
      return {status: false, message: ex.message}
    end

    private

    def validate_request
      raise UpdateExamError, 'Exam does not exists' if exam.nil?
    end
  end
end
