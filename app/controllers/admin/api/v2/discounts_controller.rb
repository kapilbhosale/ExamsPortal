class Admin::Api::V2::DiscountsController < Admin::Api::V2::ApiController
  before_action :authorize_request, only: [:create, :remove_discount]

  def index
    if params[:student_id].present?
      student = Student.find_by(id: params[:student_id])
      @discounts = Discount.where(org_id: current_org.id).valid_discount.where(
        parent_mobile: student&.parent_mobile
      )
    else
      @discounts = Discount.where(org_id: current_org.id).valid_discount.where(
        roll_number: discount_params[:cet_roll_number],
        parent_mobile: discount_params[:parent_mobile]
      )

      if @discounts.blank? && discount_params[:student_mobile].present?
        @discounts = Discount.where(org_id: current_org.id).valid_discount.where(
          roll_number: discount_params[:cet_roll_number],
          parent_mobile: discount_params[:student_mobile]
        )
      end

      if @discounts.blank? && discount_params[:student_mobile].present?
        @discounts = Discount.where(org_id: current_org.id).valid_discount.where(
          parent_mobile: discount_params[:student_mobile]
        )
      end
    end
  end

  def list_discounts
    if current_admin.roles.exclude?('list_discounts')
      render json: {message: 'not permitted'}, status: :unauthorized and return
    end

    query = params[:query]
    if query.present?
      @discounts = Discount
        .where(org_id: current_org.id)
        .valid_discount.where(
        'parent_mobile LIKE ? OR roll_number LIKE ? OR student_name ILIKE ? OR student_mobile ILIKE ?',
        "%#{query}%",
        "%#{query}%",
        "%#{query}%",
        "%#{query}%"
      ).order('created_at DESC')
    else
      @discounts = Discount.where(org_id: current_org.id).valid_discount.limit(20)
    end
  end

  def create
    if current_admin.roles.exclude?('discounts')
      render json: {message: 'not permitted'}, status: :unauthorized and return
    end

    discount = Discount.find_or_create_by({
      org_id: 1,
      type_of_discount: discount_type,
      student_name: params[:name],
      parent_mobile: params[:parentMobile],
      status: 'valid_discount',
      roll_number: params[:rollNumber],
      comment: params[:comment],
      approved_by: current_admin.name,
      amount: params[:discountAmount].to_i
    })

    render json: {} and return if discount.present?

    render json: {message: discount.errors.full_messages}, status: :unprocessable_entity
  end

  def remove_discount
    if current_org.rcc? && current_admin.roles.exclude?('remove_discounts')
      render json: {message: 'not permitted'}, status: :unauthorized and return
    end

    student = Student.find_by(id: params[:student_id])
    if student
      FeesTransaction.remove_discount(student)
      render json: {message: "Discounts removed Successfully."} and return
    else
      render json: {message: 'Student not found'}, status: :unprocessable_entity
    end
  end

  private

  def discount_type
    return "ONETIME" if params[:discountType] == 'onetime-clear'
    return "RCC_SET" if params[:discountType] == 'missing-set'
    return "SPECIAL" if params[:discountType] == 'special_req'

    return "OTHER"
  end

  def discount_params
    params.permit(:cet_roll_number, :parent_mobile, :student_mobile)
  end
end
