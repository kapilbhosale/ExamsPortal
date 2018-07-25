class DeleteStudentError < StandardError; end

module Students
  class DeleteStudentService
    attr_reader :student
    def initialize(id)
      @student = Student.find_by(id: id)
    end

    def call
      validate_request
      student.destroy!
      return {status: true, message: 'Student deleted successfully'}
    rescue DeleteStudentError, ActiveRecord::RecordInvalid => ex
      return {status: false, message: ex.message}
    end

    private

    def validate_request
      raise DeleteStudentError, 'Student must exist' if student.blank?
    end
  end
end
