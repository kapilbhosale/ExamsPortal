class Admin::Api::V2::StudentsController < Admin::Api::V2::ApiController
  def index
    # @batches = BatchFeesTemplate.where(batch_id: current_admin.batches.ids).pluck(:batch_id)
  end

  def create
    system_roll_number = Student.random_roll_number
    errors = []

    
    errors << "In-valid batch" if params[:batch_id].blank?

    if params[:parentMobile].to_s.length != 10 || params[:studentMobile].to_s.length != 10
      errors << "In-valid student or parent mobile"
    end

    errors << "In-valid batch" if params[:batch_id].blank?
    batch = Batch.find(params[:batch_id])
    errors << "In-valid batch" if batch.blank?

    render json: errors, status: :unprocessable_entity and return if errors.present?

    create_student_params = student_params.merge({
      org_id: current_org.id,
      gender: params[:gender] == 'male' ? 0 : 1,
      email: "#{system_roll_number}@#{current_org.subdomain}.eduaakar.com",
      roll_number: system_roll_number,
      password: student_params[:parent_mobile],
      raw_password: student_params[:parent_mobile]
    })

    student = Student.create(create_student_params)

    if student.errors.present?
      render json: student.errors.full_messages, status: :unprocessable_entity and return
    end

    student.batches << batch
    render json: student
  end

  private

  def student_params
    {
      name: params[:name],
      mother_name: params[:mother_name],
      date_of_birth: params[:date_of_birth],
      ssc_marks: params[:ssc_marks],
      address: params[:address],
      student_mobile: params[:studentMobile],
      parent_mobile: params[:parentMobile],
      category: params[:category]
    }
  end
end
