class AddExamError < StandardError; end

module Exams
  class AddExamService
    attr_reader :params, :name, :batch_ids
    def initialize(params)
      @params = params
      @name = params[:name]
    end

    def create
      validate_request
      @batch_ids = params[:exam][:batches]
      ActiveRecord::Base.transaction do
        @exam = Exam.new(exam_params)
        build_batches
        if @exam.save!
          
          params[:questions_zip].each do |section_id, zip_file|
            marks = {
              positive_marks: params[:positive_marks][section_id],
              negative_marks: params[:negative_marks][section_id]
            }
            Exams::Upload.new(@exam, zip_file.tempfile, section_id, marks).call
          end
          return {status: true, message: 'Exam added successfully'}
        end
      end
    rescue AddExamError, ActiveRecord::RecordInvalid => ex
      return {status: false, message: ex.message}
    end

    private

    def validate_request
      raise AddExamError, 'Name must be present' if name.nil?
      raise AddExamError, 'Name already taken' if name_already_taken?
      raise AddExamError, 'Select ZIP file to upload questions' if params[:questions_zip].nil?
      raise AddExamError, 'At least one batch must be selected' if params[:exam].nil?
    end

    def name_already_taken?
      Exam.find_by(name: name).present?
    end

    def exam_params
      params.permit(:name,
                    :description,
                    :no_of_questions,
                    :time_in_minutes,
                    :publish_result,
                    :questions_zip
      )
    end

    def build_batches
      @batch_ids&.each do |batch|
        @exam.exam_batches.build(exam_id: @exam.id, batch_id: batch.to_i)
      end
    end
  end
end
