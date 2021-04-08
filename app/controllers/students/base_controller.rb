class Students::BaseController < ApplicationController
  before_action :authenticate_student!
  before_action :set_current_org

  before_action :check_disabled_student
  attr_reader :current_org

  def set_current_org
    @current_org = Org.find_by(subdomain: request.subdomain) || current_student&.org
  end

  def check_disabled_student
    if current_student && current_student.disable?
      flash[:error] = 'Your Account is Disabled, Please contact admin/office. \n Note: 11th batch is over, kindly take new admission in 12th (if applicable). \n https://exams.smartclassapp.in/new-admission'
      sign_out current_student
      redirect_to("/student/sign_in") and return
    end
  end
end
