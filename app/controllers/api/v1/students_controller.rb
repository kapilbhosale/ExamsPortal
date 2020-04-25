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
      render json: {message: 'Invalid roll number and parent mobile'}, status: :unauthorized and return
    end

    sign_in(student)
    render json: student_json(student), status: :ok
  end

  def update_fcm_token
    if params[:fcm_token].present?
      current_student.update(fcm_token: params[:fcm_token])
      render json: student_json(current_student), status: :ok and return
    end
    render json: {}, status: :unprocessable_entity
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
        fcm_token: student.fcm_token
      }, otp: '111111'
    }
  end
end
