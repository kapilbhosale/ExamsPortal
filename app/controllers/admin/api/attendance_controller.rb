class Admin::Api::AttendanceController < Admin::Api::ApiController

  def create
    RawAttendance.create(org_id: current_org.id, data: params[:data])
    render json: {status: "ok"}, status: :ok
  end
end
