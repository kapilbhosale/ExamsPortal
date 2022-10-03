class Admin::Api::AttendanceController < Admin::Api::ApiController
  skip_before_action :authenticate

  def create
    RawAttendance.create(org_id: current_org.id, data: params[:attendanceData])
    render json: {status: "ok"}, status: :ok
  end
end
