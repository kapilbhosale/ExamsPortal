class Students::BaseController < ApplicationController
  before_action :authenticate_student!
  before_action :set_current_org

  attr_reader :current_org
  def set_current_org
    @current_org = Org.find_by(subdomain: request.subdomain) || current_student&.org
  end
end
