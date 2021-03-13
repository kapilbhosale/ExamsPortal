class DeleteStudentError < StandardError; end

module Students
  class DeleteStudentService
    attr_reader :student, :org
    def initialize(id, org)
      @student = Student.find_by(id: id)
      @org = org
    end

    def call
      validate_request
      batches = student.batches
      student.destroy!
      batches.each do |batch|
        batch.re_count_students
      end
      return {status: true, message: 'Student deleted successfully'}
    rescue DeleteStudentError, ActiveRecord::RecordInvalid => ex
      return {status: false, message: ex.message}
    end

    private

    def validate_request
      raise DeleteStudentError, 'Student must exist' if student.blank?
      raise DeleteStudentError, 'Student not belongs to your org' if student.org_id != org.id
    end
  end
end
