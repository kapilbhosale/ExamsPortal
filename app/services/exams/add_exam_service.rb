class AddExamError < StandardError; end

module Exams
  class AddExamService
    attr_reader :params, :name
    def initialize(params)
      @params = params
      @name = params[:name]
    end

    def create
      validate_request
      @exam = Exam.new(exam_params)
      if @exam.save!
        Exams::Upload.new(@exam, params[:questions_zip].tempfile).call
        return {status: true, message: 'Exam added successfully'}
      end
    rescue AddExamError, ActiveRecord::RecordInvalid => ex
      return {status: false, message: ex.message}
    end

    private

    def validate_request
      raise AddExamError, 'Name must be present' if name.nil?
      raise AddExamError, 'Name already taken' if name_already_taken?
    end

    def name_already_taken?
      Exam.find_by(name: name).present?
    end

    def exam_params
      params.permit(:name,
                    :description,
                    :no_of_questions,
                    :time_in_minutes,
                    :publish_result)
    end
  end
end
