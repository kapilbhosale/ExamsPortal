class UpdateStudentError < StandardError; end

module Students
  class UpdateStudentService
    attr_reader :student

    def initialize(params, student_params)
      @student = Student.find(params[:id])
      @params = params
      @student_params = student_params
    end

    def update
      validate_request
      build_batches

      if student.parent_mobile != @student_params[:parent_mobile]
        student.password = @student_params[:parent_mobile]
        student.raw_password = @student_params[:parent_mobile]
      end

      student.update!(@student_params)

      # SyncStudentWithAppService.new(student).sync

      return {status: true, message: 'Student updated successfully'}
    rescue UpdateStudentService, ActiveRecord::RecordInvalid => ex
      return {status: false, message: ex.message}
    end

    private

    def validate_request
      raise UpdateStudentError, 'Student does not exist'if student.blank?
    end

    def build_batches
      @batch_ids = @params[:student][:batches]&.each&.map{|id| id.to_i}
      if @batch_ids.present?
        existing_batch_ids = StudentBatch.where(student_id: student.id).map(&:batch_id)
        ids_to_delete = existing_batch_ids - @batch_ids
        ids_to_add = @batch_ids - existing_batch_ids
        ids_to_delete.each do |id|
          StudentBatch.find_by(student_id: student.id, batch_id: id).destroy
        end
        ids_to_add.each do |batch|
          student&.student_batches&.build(student_id: student.id, batch_id: batch)
        end
      end
    end
  end
end
