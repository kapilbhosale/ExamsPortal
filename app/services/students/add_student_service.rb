class AddStudentError < StandardError; end

module Students
  class AddStudentService
    attr_reader :student_params, :batch_ids

    def initialize(student_params, batch_ids)
      @student_params = student_params
      @batch_ids = batch_ids
    end

    def call
      @student = Student.new(student_params)
      build_batches
      @student.save!
      return {status: true, message: 'Student created successfully'}
    rescue AddStudentError, ActiveRecord::RecordInvalid => ex
      return {status: false, message: ex.message}
    end

    private

    def validate_request
      raise AddStudentError, 'Name must be present' if name.blank?
    end

    def build_batches
      @batch_ids&.each do |batch|
        @student.student_batches.build(student_id: @student.id, batch_id: batch.to_i)
      end
    end
  end
end
