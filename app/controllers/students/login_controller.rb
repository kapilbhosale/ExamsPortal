class Students::LoginController < Students::BaseController
  before_action :authenticate_student!, except: [:authorise, :otp_input, :process_otp]
  skip_before_action :verify_authenticity_token, only: [:authorise, :otp_input, :process_otp]

  def authorise
    if request.subdomain == 'app' || request.subdomain == 'demo'
      student = Student.find_by(
        roll_number: login_params[:login],
        parent_mobile: login_params[:password]
      )
    else
      student = Student.find_by(
        org_id: current_org.id,
        roll_number: login_params[:login],
        parent_mobile: login_params[:password]
      )
    end

    if student&.valid_password?(login_params[:password])
      student.remember_me = login_params[:remember_me]

      if student.disable?
        if current_org.rcc?
          flash[:error] = 'Dear student, If you have taken admission for 12th kindly login using your new 12th Roll number. If not then kindly confirm your admission as soon as possible. 11th App has been closed. \n https://exams.smartclassapp.in/new-admission'
        else
          flash[:error] = 'your account is disabled, please contact office.'
        end
          sign_out student
        redirect_to("/student/sign_in") and return
      end

      if request.subdomain == 'demo'
        sign_in_and_redirect(student, event: :authentication)
      end

      # change it to bhargav
      if request.subdomain == 'bhargav'
        student.generate_and_send_otp
        redirect_to("/students/otp_input?student_id=#{student.id}") and return
      else
        if student.app_login == true
          flash[:error] = "You using Mobile App. Details: #{student.deviceName}, #{student.brand}, #{student.manufacturer}. Contact for help: #{current_org&.data&.dig('admin_contacts').to_s}"
          redirect_to("/student/sign_in") and return
        end
        if student.is_laptop_login == false
          # save cookies somehow.
          cookies.signed["laptop_login_cookie_#{student.id}"] = { value: student.parent_mobile, expires: 1.year, httponly: true }
          student.is_laptop_login = true
          student.save
          sign_in_and_redirect(student, event: :authentication)
        else
          stored_cookie = cookies.signed["laptop_login_cookie_#{student.id}"]
          if student.parent_mobile == stored_cookie
            sign_in_and_redirect(student, event: :authentication)
          else
            flash[:error] = "New laptop login found. Use same laptop and browser you used earlier. Contact for help: #{current_org&.data&.dig('admin_contacts').to_s}"
            redirect_to("/student/sign_in") and return
          end
        end
      end
    else
      flash[:error] = "Invalid Login, Please try again. Contact for help: #{current_org&.data&.dig('admin_contacts').to_s}"
      redirect_to("/student/sign_in") and return
    end
  end

  def otp_input
    @student_id = params[:student_id]
  end

  def process_otp
    student = Student.find_by(id: params[:user_id])
    student.reset_apps if student.present?
    if params[:otp] == ROTP::TOTP.new(Base32.encode(student.parent_mobile), {interval: 1.day}).now
      cookies.signed["laptop_login_cookie_#{student.id}"] = { value: student.parent_mobile, expires: 1.year, httponly: true }
      student.is_laptop_login = true
      student.save
      sign_in_and_redirect(student, event: :authentication)
    else
      flash[:error] = "Invalid OPT, Please try agian."
      redirect_to("/students/otp_input?student_id=#{student.id}")
    end
  end

  private

  def login_params
    params.require(:student).permit(:login, :password, :remember_me)
  end
end
