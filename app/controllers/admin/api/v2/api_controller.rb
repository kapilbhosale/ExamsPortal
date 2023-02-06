class Admin::Api::V2::ApiController < ApplicationController
  before_action :authenticate
  before_action :set_current_org
  before_action :set_default_response_format
  protect_from_forgery with: :null_session

  attr_reader :current_org, :current_admin

  def authenticate
    authorize_request #|| render_unauthorized
  end

  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      @decoded = JWT.decode(header, Rails.application.secrets.secret_key_base.to_s)[0]
      @current_admin = Admin.find(@decoded["id"])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized and return
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized and return
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
    @current_org = Org.find_by(subdomain: request.subdomain) || @current_admin.org
  end

end
