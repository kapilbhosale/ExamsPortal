class Admin::Api::AttendanceController < Admin::Api::ApiController
  skip_before_action :authenticate

  def create
    if params[:username] == "RCC@attendance" && params[:password] == "RandomPassword@758463" && params[:mac] == "c6:f0:5d:04:19:f8"
      RawAttendance.create(org_id: current_org.id, data: params[:attendanceData])
      render json: {status: "ok"}, status: :ok and return
    else
      render json: {status: "not-accepted"}, status: :unprocessable_entity and return
    end
  end

  def machines
    if params[:username] == "RCC@attendance" && params[:password] == "RandomPassword@758463"
      att_machines = AttMachine.where(org_id: current_org.id, disabled: false).map do |mac|
        { ip: mac.ip_address, name: mac.name }
      end
      render json: { machines: att_machines }, status: :ok and return
    end
    render json: { machines: [] }, status: :ok
  end
end
