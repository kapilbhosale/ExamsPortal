class Students::LoginController < Students::BaseController
  before_action :authenticate_student!, except: [:authorise]
  skip_before_action :verify_authenticity_token, only: [:authorise]

  def authorise
    student = Student.find_by(
      roll_number: login_params[:login],
      parent_mobile: login_params[:password]
    )
    if student&.valid_password?(login_params[:password])
      student.remember_me = login_params[:remember_me]
      sign_in_and_redirect(student, event: :authentication)
    else
      flash[:error] = "Invalid Login, Please try again."
      redirect_to "/student/sign_in"
    end
  end

  private

  def login_params
    params.require(:student).permit(:login, :password, :remember_me)
  end
end
