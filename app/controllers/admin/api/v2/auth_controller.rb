class Admin::Api::V2::AuthController < Admin::Api::V2::ApiController
  skip_before_action :authenticate
  skip_before_action :set_current_org

  def get_token
    refresh_token = params[:token]

    if refresh_token
      admin_id = REDIS_CACHE.get(refresh_token)
      admin = Admin.find_by(id: admin_id)
      if admin
        token = admin.token
        render json: { token: token, message: "Auth Successful, redirecting..." }, status: :ok and return
      end
    end

    render json: { token: nil, message: "Token Expired, Please refresh 'Students' page and try again." }
  end

  def login
    admin = Admin.find_for_authentication(username: params[:username])
    admin.valid_password?(params[:password])

    if admin.valid_password?(params[:password])
      token = admin.token
      render json: {
        token: token,
        admin: admin
        }, status: :ok and return
    end

    render json: {message: "Invalid username or password" }, status: :unprocessable_entity
  end
end
