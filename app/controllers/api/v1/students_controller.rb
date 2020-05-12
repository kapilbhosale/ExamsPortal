# frozen_string_literal: true

class Api::V1::StudentsController < Api::V1::ApiController
  skip_before_action :authenticate, only: [:login]
  skip_before_action :verify_authenticity_token

  def login
    student = Student.find_by(
      roll_number: params[:rollNumber],
      parent_mobile: params[:parentMobile]
    )
    if student.blank?
      render json: {message: 'Invalid roll number or parent mobile. Please check and re-enter.'}, status: :unauthorized and return
    end

    if student.app_login?
      render json: { message: 'You are ALREADY logged in some other mobile. Please Contact Admin.'}, status: :unauthorized and return
    end

    sign_in(student)
    student.update(app_login: true)

    render json: student_json(student), status: :ok
  end

  def update_fcm_token
    if params[:fcm_token].present?
      current_student.update(fcm_token: params[:fcm_token])
      render json: student_json(current_student), status: :ok and return
    end
    render json: { message: 'No fcm_token present in params to update' }, status: :unprocessable_entity
  end

  private

  def student_json(student)
    {
      student: {
        id: student.id,
        student_id: student.id,
        roll_number: student.roll_number,
        name: student.name,
        parent_mobile_number: student.parent_mobile,
        api_key: student.api_key,
        fcm_token: student.fcm_token,
        vimeo_access_token: current_org&.vimeo_access_token
      }, otp: '111111'
    }
  end
end
