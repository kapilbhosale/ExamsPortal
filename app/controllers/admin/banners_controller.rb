class Admin::BannersController < Admin::BaseController
  ITEMS_PER_PAGE = 20
  def index
    @banners = Banner.includes(:org)
      .where(org: current_org)
      .includes(:batches, :batch_banners)
      .where(batches: {id: current_admin.batches&.ids})
      .all
      .order(id: :desc)
      .page(params[:page])
      .per(params[:limit] || ITEMS_PER_PAGE)
  end

  def new
    @batches_with_group = Batch.where(org: current_org, id: current_admin.batches&.ids).all_batches.order(:id).group_by(&:batch_group_id)
    @batch_groups = BatchGroup.where(org: current_org).order(:id).index_by(&:id)
  end

  def create
    banner = Banner.new
    banner.on_click_url = banner_params[:on_click_url]
    banner.image = banner_params[:image]
    banner.org_id = current_org.id
    if banner.save
      if params[:batches].present?
        params[:batches].each do |batch_id|
          BatchBanner.create(banner: banner, batch_id: batch_id)
        end
      end
      flash[:success] = 'Banner added, successfully'
    else
      flash[:error] = "Cannot add Banner link, #{banner.errors.full_messages.join(',')}"
    end

    redirect_to admin_banners_path
  end

  def destroy
    banner = Banner.where(org_id: current_org.id).where(id: params[:id]).last
    if banner
      banner.active = !banner.active
      banner.save
      flash[:success] = 'Banner status changed, successfully'
    else
      flash[:error] = 'Banner not found'
    end
    redirect_to admin_banners_path
  end


  private

  def banner_params
    params.permit(:image, :on_click_url)
  end
end
