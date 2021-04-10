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
      flash[:error] = 'Dear student, If you have taken admission for 12th kindly login using your new 12th Roll number. If not then kindly confirm your admission as soon as possible. 11th App has been closed. \n https://exams.smartclassapp.in/new-admission'
      sign_out current_student
      redirect_to("/student/sign_in") and return
    end
  end
end
