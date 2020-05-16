class UpdateExamError < StandardError; end

module Exams
  class UpdateExamService
    attr_reader :exam_params, :exam, :org
    def initialize(exam_params, org)
      @exam_params = exam_params
      @exam = Exam.find_by(id: exam_params[:id])
      @org = org
    end

    def update
      validate_request
      build_batches
      exam.update!({publish_result: exam_params[:exam][:publish_result]})
      return {status: true, message: 'Exam details updated successfully'}
    rescue UpdateExamError, ActiveRecord::RecordInvalid => ex
      return {status: false, message: ex.message}
    end

    private

    def validate_request
      raise UpdateExamError, 'Exam does not exists' if exam.nil?
      raise UpdateExamError, 'Exam not belongs to your org' if exam.org != org
    end

    def build_batches
      @batch_ids = @exam_params[:exam][:batches]&.each&.map{|id| id.to_i}
      if @batch_ids.present?
        existing_batch_ids = ExamBatch.where(exam_id: exam.id).map(&:batch_id)
        ids_to_delete = existing_batch_ids - @batch_ids
        ids_to_add = @batch_ids - existing_batch_ids
        ids_to_delete.each do |id|
          ExamBatch.find_by(exam_id: exam.id, batch_id: id).destroy
        end
        ids_to_add.each do |batch|
          exam&.exam_batches&.build(exam_id: exam.id, batch_id: batch)
        end
      end
    end
  end
end
