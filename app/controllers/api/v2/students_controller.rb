class Api::V2::StudentsController < Api::V2::ApiController
  skip_before_action :authenticate, only: [:login, :register]
  skip_before_action :verify_authenticity_token

  def login
    @student = Student.find_by(
      org_id: current_org&.id,
      roll_number: params[:rollNumber],
      parent_mobile: params[:parentMobile]
    )

    if @student.blank?
      render json: {
        message: 'Invalid roll number or parent mobile. Please check and re-enter.'
      }, status: :unauthorized and return
    end

    if @student.disable?
      render json: {
        message: 'Your Account is Disabled, Please contact admin/office.'
      }, status: :unauthorized and return
    end

    unless login_allowed?
      if @student.is_laptop_login
        message = 'You are using Laptop for access, please continue using latop only.'
      else
        message = 'You are ALREADY logged in some other mobile. \n'
        message += "#{@student.manufacturer}, #{@student.brand}, #{@student.deviceName}.\n"
      end

      message += 'Please Contact Admin. '
      message += @student.org&.data&.dig('admin_contacts').to_s

      render json: { message: message }, status: :unauthorized and return
    end

    if current_org.sstl?
      @student.reset_apps
      @student.generate_and_send_otp
    end

    sign_in(@student)

    @student.update(
      app_login: true,
      deviceUniqueId: device_params[:deviceUniqueId],
      deviceName: device_params[:deviceName],
      manufacturer: device_params[:manufacturer],
      brand: device_params[:brand]
    )

    @exam_portal_link = "#{helpers.full_domain_path}/students/auto-auth"
    @exam_portal_link += "?r=#{@student&.roll_number}&m=#{@student&.parent_mobile}"
  end

  def update_fcm_token
    if params[:fcm_token].present? && current_student.fcm_token.blank?
      current_student.update(fcm_token: params[:fcm_token])
      render json: student_json(current_student), status: :ok and return
    end
    render json: { message: 'No fcm_token present in params to update' }, status: :unprocessable_entity
  end

  def progress_report
    exams = Exam.includes(:batches).where(batches: { id: current_student.batches.ids }).where(is_pr_generated: true)
    progress_report_data = ProgressReport.where(student_id: current_student.id).order(exam_date: :desc)
    data = {}
    progress_report_data.each do |prd|
      key = "#{prd.exam_id || 0}-#{prd&.exam_name&.parameterize || 'default-exam'}"

      data[key] = {
        exam_date: prd.exam_date,
        present: true,
        data: {
          exam_date: prd.exam_date,
          is_imported: prd.is_imported,
          exam_name: prd.exam_name,
          data: prd.data.is_a?(Hash) ? prd.data : JSON.parse(prd.data || '{}'),
          percentage: prd.percentage,
          rank: prd.rank
        }
      }
    end
    exams.each do |exam|
      key = "#{exam.id || 0}-#{exam.name.parameterize}"
      data[key] ||= {
        exam_date: exam.show_exam_at,
        present: false,
        data: {
          exam_date: exam.show_exam_at.strftime("%d-%b-%Y"),
          is_imported: false,
          exam_name: exam.name,
          data: {},
          percentage: 0,
          rank: nil
        }
      }
    end
    @data = Hash[data.sort_by{|k, v| v[:exam_date] || Date.today }.reverse].values
    render json: {data: @data}
  end

  def register
    student = Student.create({
      roll_number: 10_000,
      org_id: current_org.id,
      parent_mobile: params[:parentMobileNumber],
      student_mobile: params[:mobileNumber],
      name: params[:fullName],
      address: "#{params[:education]}|#{params[:city]}",
      email: params[:email],
      password: params[:parentMobileNumber],
      raw_password: params[:parentMobileNumber]
    })

    # student.batches << Batch.find(775)
    # student.save

    if student.errors.blank?
      render json: student, status: :ok
    else
      render json: {message: student.errors.full_messages.join(', ')}, status: :unprocessable_entity
    end
  end

  private

  def login_allowed?
    # add OPT config based condition for org.
    return true if current_org.sstl?
    return true if demo_account?(@student)
    return false if @student.is_laptop_login
    return true unless @student.app_login?
    return true if device_params[:deviceUniqueId].present? && @student.deviceUniqueId.blank?
    return true if @student.deviceUniqueId == device_params[:deviceUniqueId]
    return false if @student.app_login? && @student.deviceUniqueId != device_params[:deviceUniqueId]

    false
  end

  def demo_account?(student)
    return true if student.roll_number == 101 && student.parent_mobile == '999999'
    return true if student.roll_number == 1001 && student.parent_mobile == '999999'

    false
  end

  def device_params
    {
      deviceUniqueId: params[:deviceUniqueId] || request.headers['deviceUniqueId'],
      deviceName: params[:deviceName] || request.headers['deviceName'],
      manufacturer: params[:manufacturer] || request.headers['manufacturer'],
      brand: params[:brand] || request.headers['brand']
    }
  end
end