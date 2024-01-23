class Api::V2::ApiController < ApplicationController
  before_action :authenticate
  before_action :set_current_org
  before_action :set_default_response_format
  protect_from_forgery with: :null_session
  before_action :update_device_info
  before_action :check_disabled_student

  attr_reader :current_org

  def authenticate
    authenticate_token || render_unauthorized
  end

  def authenticate_token
    authenticate_with_http_token do |token, _options|
      @current_student = Student.find_by(api_key: token)
    end
  end

  def render_unauthorized
    self.headers['WWW-Authenticate'] = 'Token realm="Application"'
    render json: { message:"Authorization failed" }, status: :unauthorized
  end

  def update_device_info
    if @current_student.present? && @current_student.deviceUniqueId.blank? && request.headers['deviceUniqueId'].present?
      @current_student.update(
        app_login: true,
        deviceUniqueId: request.headers['deviceUniqueId'],
        deviceName: request.headers['deviceName'],
        manufacturer: request.headers['manufacturer'],
        brand: request.headers['brand']
      )
    end
  end

  def set_default_response_format
    request.format = :json
  end

  def set_current_org
    if Rails.env.development?
      @current_org = Org.first
      return
    end

    @current_org = Org.find_by(subdomain: request.subdomain) || @current_student.org
  end

  def check_disabled_student
    if @current_student && @current_student.disable?
      self.headers['WWW-Authenticate'] = 'Token realm="Application"'
      render json: { message:"Authorization failed" }, status: :unauthorized and return
    end
  end
end
