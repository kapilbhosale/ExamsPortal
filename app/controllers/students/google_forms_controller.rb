class Students::GoogleFormsController < Students::BaseController
  skip_before_action :authenticate_student!
  skip_before_action :verify_authenticity_token

  def register
    student = Student.find_by(
      roll_number: params[:google_form][:Roll_Number],
      parent_mobile: params[:google_form][:Parent_Mobilenumber]
    )
    if student.present?
      student.form_data.create(
        form_id: 'RnQVEwQu4raYp5Gh9',
        data: params[:google_form]
      )
      render json: { stauts: true }
    else
      render json: { stauts: false, message: 'no student found' }
    end
  end
end
