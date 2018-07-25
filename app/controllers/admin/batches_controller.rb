class Admin::BatchesController < ApplicationController
  before_action :authenticate_admin!

  def index
    @batches = Batch.all
  end

  def new
    @batch = Batch.new
  end

  def create
    @response = Batches::AddBatchService.new(params[:batch][:name]).call
    set_flash
    redirect_to admin_batches_path
  end

  def show
    @batch = Batch.find_by(id: params[:id])
  end

  def edit
    @batch = Batch.find_by(id: params[:id])
  end

  def update
    @response = Batches::UpdateBatchService.new(params[:id], params[:batch][:name]).call
    set_flash
    redirect_to admin_batches_path
  end

  def destroy
    @response = Batches::DeleteBatchService.new(params[:id]).call
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
