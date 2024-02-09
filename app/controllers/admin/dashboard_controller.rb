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

  def discounts
    redirect_to "/admin" unless current_admin.roles.include?('discounts')
  end

  def import_discounts
    csv_text = File.read(params[:discounts_csv].path)
    csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
    if csv.headers == ["sr_no", "roll_no", "name", "student_mobile", "parent_mobile", "stud_class", "batch_fees", "con_percent", "con_amount", "amount_pay"]
      Discount.import_csv(params[:discounts_csv].path, params[:note], current_admin.id, params[:overwrite] == "true")
      render json: {message: "processing data, operation will complete in some time."}
    else
      render json: {message: "ERROR: Invalid CSV file. Please check the headers."}
    end
  end

  private

  def set_flash
    key = @response[:status] ? :success : :warning
    flash[key] = @response[:message]
  end
end
