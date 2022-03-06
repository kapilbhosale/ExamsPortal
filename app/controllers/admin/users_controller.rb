class Admin::UsersController < Admin::BaseController
  before_action :check_permissions
  def index
    @admins = Admin.where(org: current_org)
  end

  def update
    error = nil

    unless current_admin.valid_password?(params[:admin][:current_password])
      error = "current password is wrong"
      flash[:error] = error
      redirect_to profile_admin_users_path and return
    end

    if params[:admin][:new_password].length <= 7
      error = "password must be of length more than 8 characters"
      flash[:error] = error
      redirect_to profile_admin_users_path and return
    end

    if params[:admin][:new_password] != params[:admin][:re_new_password]
      error = "new passwords do not match, please try agian."
      flash[:error] = error
      redirect_to profile_admin_users_path and return
    end

    current_admin.password = params[:admin][:new_password]
    if current_admin.save
      flash[:success] = 'password updated, successfully.'
      redirect_to '/admin'
    else
      flash[:error] = current_admin.errors.full_messages.join(', ')
      redirect_to profile_admin_users_path
    end
  end

  def profile
    @admin = current_admin
  end

  private

  def check_permissions
    redirect_to '/404' unless current_admin.can_manage(:admin_users)
  end
end
