class Admin::DashboardController < Admin::BaseController

  def show
  end

  def profile
    @admin = Admin.find_by(id: current_admin.id)
  end

  def update_profile
    @response = AdminModule::UpdateAdminService.new(params).update
    set_flash
    redirect_to admin_dashboard_profile_path
  end

  def import_halltickets
    render json: Student.import_hallticket_csv(params[:hallticket_csv].path)
  end

  private

  def set_flash
    key = @response[:status] ? :success : :warning
    flash[key] = @response[:message]
  end
end
