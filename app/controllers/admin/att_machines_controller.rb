class Admin::AttMachinesController < Admin::BaseController
  before_action :check_permissions

  def create
    AttMachine.create(att_machine_params.merge(org_id: current_org.id))
    flash[:success] = "Attendance Machine Added Succesfully."
    redirect_to settings_admin_attendance_index_path
  end

  def disable
    machine = AttMachine.find_by(id: params[:att_machine_id])
    if machine
      machine.update(disabled: true)
      flash[:success] = "Successful"
    else
      flash[:success] = "can not Disable Machine"
    end

    redirect_to settings_admin_attendance_index_path
  end

  def enable
    machine = AttMachine.find_by(id: params[:att_machine_id])
    if machine
      machine.update(disabled: false)
      flash[:success] = "Successful"
    else
      flash[:success] = "can not Enable Machine"
    end

    redirect_to settings_admin_attendance_index_path
  end

  private

  def check_permissions
    redirect_to '/404' unless current_admin.can_manage(:attendance)
  end

  def att_machine_params
    params.permit(:name, :ip_address)
  end
end
