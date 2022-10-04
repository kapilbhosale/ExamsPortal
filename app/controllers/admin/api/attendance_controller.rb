class Admin::Api::AttendanceController < Admin::Api::ApiController
  skip_before_action :authenticate

  def create
    if params[:username] == "RCC@attendance" && params[:password] == "RandomPassword@758463"
      RawAttendance.create(org_id: current_org.id, data: params[:attendanceData])
    end
    render json: {status: "ok"}, status: :ok
  end
end
