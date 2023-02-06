class Admin::Api::V2::StudentsController < Admin::Api::V2::ApiController
  def index
    # @batches = BatchFeesTemplate.where(batch_id: current_admin.batches.ids).pluck(:batch_id)
  end

  def create
    system_roll_number = Student.random_roll_number
    errors = []

    if params[:parent_mobile].length != 10 || params[:student_mobile].length != 10
      errors << "In-valid student or parent mobile"
    end

    errors << "In-valid batch" if params[:batch_id].blank?

    render json: errors, status: :unprocessable_entity and return if errors.present?

    create_student_params = student_params.merge({
      org_id: current_org.id,
      gender: params[:gender] == 'male' ? 0 : 1,
      email: "#{system_roll_number}@#{current_org.subdomain}.eduaakar.com",
      roll_number: system_roll_number,
      password: params[:parent_mobile],
      raw_password: params[:parent_mobile]
    })

    student = Student.create(create_student_params)

    if student.errors.present?
      render json: student.errors.full_messages, status: :unprocessable_entity and return
    end

    render json: student
  end

  private

  def student_params
    params.permit(
      :name,
      :mother_name,
      :date_of_birth,
      :ssc_marks,
      :address,
      :student_mobile,
      :parent_mobile,
      :category
    )
  end
end
