class Admin::BatchesController < Admin::BaseController

  def index
    @batches = Batch.where(org: current_org, id: current_admin.batches&.ids).includes(:batch_group).all.order(:id)
  end

  def new
    @batch = Batch.new
    @batch_groups = BatchGroup.where(org: current_org).order(:id).all
  end

  def create
    @response = Batches::AddBatchService.new(params[:batch][:name], current_org, params[:batch_group_id]).call
    current_admin.batches << @response[:batch] if @response[:status]
    set_flash
    redirect_to admin_batches_path
  end

  def disable
    batch = Batch.find_by(org: current_org, id: params[:batch_id])
    if batch.present?
      batch.students.find_each do |student|
        if student.batches.count == 1
          student.update!(disable: true, app_reset_count: student.app_reset_count + 1)
        else
          student.batches.delete(batch)
        end
      end
      batch.recount_disable
      flash[:success] = 'Students disabled, successfully.'
    else
      flash[:error] = 'Error in disabling Student App Login.'
    end
    redirect_to admin_batches_path
  end

  def show
    @batch = Batch.find_by(org: current_org, id: params[:id])
  end

  def edit
    @batch = Batch.find_by(org: current_org, id: params[:id])
    @batch_groups = BatchGroup.where(org: current_org).order(:id).all
  end

  def update
    @response = Batches::UpdateBatchService.new(params[:id], params[:batch][:name], params[:batch_group_id]).call
    set_flash
    redirect_to admin_batches_path
  end

  def destroy
    @response = Batches::DeleteBatchService.new(params[:id], current_org).call
    set_flash
    redirect_to admin_batches_path
  end

  private

  def batch_params
    params.require(:batch).permit(:name)
  end

  def set_flash
    key = @response[:status] ? :success : :warning
    flash[key] = @response[:message]
  end
end
