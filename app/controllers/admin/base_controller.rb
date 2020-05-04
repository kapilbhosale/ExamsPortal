class Admin::BaseController < ApplicationController
  before_action :authenticate_admin!, :set_current_org
  layout 'admin/dashboard'
  attr_reader :current_org

  def set_current_org
    @current_org = Org.find_by(subdomain: request.subdomain)
  end
end
