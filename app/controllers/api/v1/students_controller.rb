# frozen_string_literal: true

class Api::V1::StudentsController < Api::V1::ApiController
  skip_before_action :authenticate, only: [:login]
  skip_before_action :set_current_org, only: [:login]
  skip_before_action :verify_authenticity_token

  require "base32"

  def login
    if request.subdomain == 'app' || request.subdomain == 'demo'
      student = Student.find_by(
        roll_number: params[:rollNumber],
        parent_mobile: params[:parentMobile]
      )
    else
      org = Org.find_by(subdomain: request.subdomain)
      student = Student.find_by(
        org_id: org&.id,
        roll_number: params[:rollNumber],
        parent_mobile: params[:parentMobile]
      )
    end

    if student.blank?
      render json: {message: 'Invalid roll number or parent mobile. Please check and re-enter.'}, status: :unauthorized and return
    end

    if student.disable? && request.subdomain == 'exams'
      render json: { message: 'Dear student, If you have taken admission for 12th kindly login using your new 12th Roll number. If not then kindly confirm your admission as soon as possible. 11th App has been closed. \n https://exams.smartclassapp.in/new-admission'}, status: :unauthorized and return
    end

    if student.disable?
      render json: { message: 'Your Account is disabled, please contact Coacing class office'}, status: :unauthorized and return
    end

    unless login_allowed?(student)
      if student.is_laptop_login
        message = "You are using Laptop for access, please continue using latop only."
      else
        message = "You are ALREADY logged in some other mobile. \n"
        message += "#{student.manufacturer}, #{student.brand}, #{student.deviceName}.\n"
      end

      message += 'Please Contact Admin. '
      message += student.org&.data&.dig('admin_contacts').to_s

      render json: { message: message }, status: :unauthorized and return
    end

    if request.subdomain == 'bhargav'
      student.reset_apps
      @otp = student.generate_and_send_otp
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
    if params[:fcm_token].present? && current_student.fcm_token != params[:fcm_token]
      current_student.update(fcm_token: params[:fcm_token])
      render json: student_json(current_student), status: :ok and return
    end
    render json: { message: 'No fcm_token present in params to update' }, status: :unprocessable_entity
  end

  def is_form_registered
    form_url = 'https://forms.gle/RnQVEwQu4raYp5Gh9'
    render json: { status: current_student.form_data.present?, ulr: form_url }
  end

  private

  # return true if allowed to login, false if not allowed to login
  def login_allowed?(student)
    # add OPT config based condition for org.
    return true if request.subdomain == 'bhargav'
    return true if request.subdomain == 'demo'

    return true if demo_account?(student)

    return false if student.is_laptop_login

    return true if !student.app_login?

    if device_params[:deviceUniqueId].present? && student.deviceUniqueId.blank?
      return true
    end

    return true if student.deviceUniqueId == device_params[:deviceUniqueId]

    return false if student.app_login? && student.deviceUniqueId != device_params[:deviceUniqueId]

    false
  end

  def demo_account?(student)
    return true if student.roll_number == 101 && student.parent_mobile == '999999'
    return true if student.roll_number == 100 && student.parent_mobile == '1234567890'
    return true if student.roll_number == 1001 && student.parent_mobile == '999999'

    return true if student.roll_number == 1001 && student.parent_mobile == '9876543210'
    return true if student.roll_number == 3003 && student.parent_mobile == '9876543200'

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
        vimeo_access_token: student.org&.vimeo_access_token
      }, otp: (@otp || '111111')
    }
  end
end
