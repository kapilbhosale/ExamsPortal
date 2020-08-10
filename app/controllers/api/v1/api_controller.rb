class Api::V1::ApiController < ApplicationController
  before_action :authenticate
  before_action :set_current_org
  before_action :set_default_response_format
  protect_from_forgery with: :null_session

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

  def set_default_response_format
    request.format = :json
  end

  def set_current_org
    @current_org = Org.find_by(subdomain: request.subdomain) || @current_student.org
  end

end
