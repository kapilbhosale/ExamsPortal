class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :switch_databse

  def switch_databse
    ActiveRecord::Base.establish_connection(db_config)
  end

  def db_config
    @default_config ||= ActiveRecord::Base.connection.instance_variable_get("@config").dup
    return @default_config.dup.update(:database => database_name) if database_name.present?
    return @default_config
  end

  def database_name
    {
      'jmc' => 'smart_exams_v2',
      'bhosale' => 'smart_exams_v3',
      'scholars' => 'smart_exams_v3',
      'ganesh' => 'smart_exams_v3',
      'wagaj' => 'smart_exams_v3',
      'chate' => 'smart_exams_v3'
    }[request.subdomain]
  end

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
    end
  end
end
