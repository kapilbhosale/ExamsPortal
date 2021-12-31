class Admin::BatchGroupsController < Admin::BaseController
  before_action :check_permissions

  def index
    @batch_groups = BatchGroup.where(org: current_org).includes(:batches).all.order(:id)
  end

  def new
    @batch_group = BatchGroup.new
  end

  def create
    @response = BatchGroup.create(org: current_org, name: params[:batch_group][:name])
    set_flash(@response.errors.full_messages.join(', '))
    redirect_to admin_batch_groups_path
  end

  def edit
    @batch_group = BatchGroup.find_by(org: current_org, id: params[:id])
  end

  def update
    batch_group = BatchGroup.find_by(org: current_org, id: params[:id])
    batch_group.update(name: params[:batch_group][:name])
    redirect_to admin_batch_groups_path
  end

  private

  def batch_params
    params.require(:batch).permit(:name)
  end

  def set_flash(msg)
    key = @response[:status] ? :success : :warning
    flash[key] = msg
  end

  def check_permissions
    redirect_to '/404' unless current_admin.can_manage(:batches)
  end
end
