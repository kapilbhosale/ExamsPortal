class Admin::BatchesController < Admin::BaseController

  def index
    @batches = Batch.where(org: current_org).all
  end

  def new
    @batch = Batch.new
  end

  def create
    @response = Batches::AddBatchService.new(params[:batch][:name], current_org).call
    set_flash
    redirect_to admin_batches_path
  end

  def show
    @batch = Batch.find_by(org: current_org, id: params[:id])
  end

  def edit
    @batch = Batch.find_by(org: current_org, id: params[:id])
  end

  def update
    @response = Batches::UpdateBatchService.new(params[:id], params[:batch][:name]).call
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
