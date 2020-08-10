class AddStudentError < StandardError; end

module Students
  class AddStudentService
    attr_reader :student_params, :batch_ids, :org

    def initialize(student_params, batch_ids, org)
      @student_params = student_params
      @batch_ids = batch_ids
      @org = org
    end

    def call
      validate_request

      rand_password = student_params[:parent_mobile] #('0'..'9').to_a.shuffle.first(6).join
      email_id = "#{org.id}-#{student_params[:roll_number]}-#{student_params[:parent_mobile]}@eduaakr.com"
      student_params.merge!({email: email_id, password: rand_password, raw_password: rand_password})
      @student = Student.new(student_params)
      @student.org = org
      @student.save!

      build_batches
      # SyncStudentWithAppService.new(@student).sync

      return {status: true, message: "Student created successfully email:#{email_id},password:#{rand_password}"}
    rescue AddStudentError, ActiveRecord::RecordInvalid => ex
      return {status: false, message: ex.message}
    end

    private

    def validate_request
      raise AddStudentError, 'Name must be present' if student_params[:name].blank?
      raise AddStudentError, 'parent mobile be present' if student_params[:parent_mobile].blank?
      raise AddStudentError, 'No Batch Selected' if batch_ids.blank?
    end

    def build_batches
      @batch_ids&.each do |batch_id|
        StudentBatch.create(student_id: @student.id, batch_id: batch_id.to_i)
      end
    end
  end
end
