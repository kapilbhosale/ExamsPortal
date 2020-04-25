class Api::V1::ApiController < ApplicationController
  before_action :authenticate
  before_action :set_default_response_format
  protect_from_forgery with: :null_session

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
    render json: { status: 'failure', message:"Authorization failed" }, status: :bad_request
  end

  def set_default_response_format
    request.format = :json
  end

end
