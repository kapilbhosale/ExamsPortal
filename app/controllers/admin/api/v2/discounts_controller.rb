class Admin::Api::V2::DiscountsController < Admin::Api::V2::ApiController
  def index
    @discounts = Discount.where(org_id: current_org.id).valid_discount.where(
      roll_number: discount_params[:cet_roll_number],
      parent_mobile: discount_params[:parent_mobile]
    )
  end

  private
  def discount_params
    params.permit(:cet_roll_number, :parent_mobile)
  end
end
