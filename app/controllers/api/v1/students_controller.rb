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
      message = "You are ALREADY logged in some other mobile. \n"
      message += "#{student.manufacturer}, #{student.brand}, #{student.deviceName}.\n"
      message += 'Please Contact Admin. '
      message += current_org&.data&.dig('admin_contacts').to_s
      render json: { message: message }, status: :unauthorized and return
    end

    sign_in(student)
    student.update(
      app_login: true,
      deviceUniqueId: device_params[:deviceUniqueId],
      deviceName: device_params[:deviceName],
      manufacturer: device_params[:manufacturer],
      brand: device_params[:brand]
    )

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

  # return true if allowed to login, false if not allowed to login
  def login_allowed?(student)
    return true if !student.app_login?

    if device_params[:deviceUniqueId].present? && student.deviceUniqueId.blank?
      return true
    end

    return true if student.deviceUniqueId == device_params[:deviceUniqueId]

    return false if student.app_login? && student.deviceUniqueId != device_params[:deviceUniqueId]

    false
  end

  def device_params 
    {
      deviceUniqueId: params[:deviceUniqueId],
      deviceName: params[:deviceName],
      manufacturer: params[:manufacturer],
      brand: params[:brand],
    }
  end

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
