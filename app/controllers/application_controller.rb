class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :password_confirmation])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  def after_sign_in_path_for(student)
    if current_admin
      '/admin/exams'
    elsif request.subdomain&.include?('videos')
      '/students/videos'
    else
      '/students/tests'
      # if (student.batches.ids & [986, 987]).present?
      #   '/students/hallticket'
      # end
    end
  end
end
