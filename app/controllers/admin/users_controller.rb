class Admin::UsersController < Admin::BaseController
  def index
    @admins = Admin.where(org: current_org)
  end
end
