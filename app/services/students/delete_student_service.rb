class DeleteStudentError < StandardError; end

module Students
  class DeleteStudentService
    attr_reader :student, :org, :admin

    def initialize(id, org, admin)
      @student = Student.find_by(id: id)
      @org = org
      @admin = admin
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
      return true if admin.roles.include?('delete_student')

      raise DeleteStudentError, 'cannot delete student with fees' if FeesTransaction.where(student_id: student.id).present?

      # TODO::remove later
      raise DeleteStudentError, 'cannot delete students for now'
    end
  end
end
