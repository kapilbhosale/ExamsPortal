class Admin::BaseController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_current_org
  before_action :verify_admin_org

  layout 'admin/dashboard'
  attr_reader :current_org

  ITEMS_PER_PAGE = 20

  def set_current_org
    @current_org = Org.find_by(subdomain: request.subdomain) || current_admin&.org
  end

  def verify_admin_org
    return if current_admin.org_id == current_org&.id

    flash[:error] = "Invalid Admin for the org: #{current_org&.subdomain}"
    sign_out current_admin
    redirect_to '/'
  end
end
