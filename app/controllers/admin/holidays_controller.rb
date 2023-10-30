class Admin::HolidaysController < Admin::BaseController
  def index
    @batches_by_ids = Batch.where(org: current_org).where(id: current_admin.batches.ids).where.not(start_time: nil).index_by(&:id)
    @holidays = BatchHoliday.where(org_id: current_org.id).where(batch_id: @batches_by_ids.keys).all.order(:holiday_date).group_by(&:holiday_date)
  end

  def new
    @batches_with_group = Batch.where(org: current_org, id: current_admin.batches&.ids).where.not(start_time: nil).order(:id).group_by(&:batch_group_id)
    @batch_groups = BatchGroup.where(org: current_org).order(:id).index_by(&:id)
  end

  def create
    params[:batch_ids].each do |batch_id|
      BatchHoliday.create(
        org_id: current_org.id,
        batch_id: batch_id,
        comment: params[:comment],
        holiday_date: Date.parse(params[:holiday_date])
      )
    end
    flash[:success] = "Holidays Added Succesfully."
    redirect_to admin_holidays_path
  end

  def destroy
    BatchHoliday.find_by(id: params[:id]).destroy
    flash[:success] = "Batch Holidays Deleted Succesfully."
    redirect_to admin_holidays_path
  end
end
