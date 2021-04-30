class Admin::MicroPaymentsController < Admin::BaseController
  ITEMS_PER_PAGE = 20
  def index
    @payment_links = MicroPayment.includes(:org)
      .where(org: current_org)
      .includes(:batches, :batch_micro_payments)
      .where(batches: {id: current_admin.batches&.ids})
      .all
      .order(id: :desc)
      .page(params[:page])
      .per(params[:limit] || ITEMS_PER_PAGE)

    @amount_by_link_id = StudentPayment.where(micro_payment_id: @payment_links.ids).success.group(:micro_payment_id).sum(:amount)
    @count_by_link_id = StudentPayment.where(micro_payment_id: @payment_links.ids).success.group(:micro_payment_id).count
  end

  def new
    @batches_with_group = Batch.where(org: current_org, id: current_admin.batches&.ids).all_batches.order(:id).group_by(&:batch_group_id)
    @batch_groups = BatchGroup.where(org: current_org).order(:id).index_by(&:id)
  end

  def create
    micro_payment = MicroPayment.new
    errors = validate_payments_data
    if errors.blank?
      micro_payment.amount = payment_params[:amount]
      micro_payment.min_payable_amount = payment_params[:min_payable_amount]
      micro_payment.link = random_slug
      micro_payment.org_id = current_org.id
      if micro_payment.save
        if params[:batches].present?
          params[:batches].each do |batch_id|
            BatchMicroPayment.create(micro_payment: micro_payment, batch_id: batch_id)
          end
        end
        flash[:success] = 'Payment Link added, successfully'
      else
        flash[:error] = "Cannot add payment link, #{micro_payment.errors.full_messages.join(',')}"
      end
    else
      flash[:error] = errors.join(', ')
    end

    redirect_to admin_micro_payments_path
  end

  def show
    @micro_payment = MicroPayment.find_by(id: params[:id])
    @student_payments = StudentPayment.where(micro_payment_id: @micro_payment.id).includes(:student)
  end

  def destroy
    micro_payment = MicroPayment.find_by(id: params[:id])
    micro_payment.update(active: false)
    flash[:success] = "Link Deactivated sucessfully"
    redirect_to admin_micro_payments_path
  end

  private

  def random_slug
    slug = Array.new(6){[*'0'..'9', *'a'..'z', *'A'..'Z'].sample}.join
    return slug if MicroPayment.where(link: slug).count == 0

    random_slug
  end

  def validate_payments_data
    errors = []
    errors << 'Invalid Amount' if payment_params[:amount].to_i == 0
    errors << 'Invalid Min Payable Amount' if payment_params[:min_payable_amount].to_i == 0
    if payment_params[:min_payable_amount].to_i > payment_params[:amount].to_i
      errors << 'Min Payable amount cannot be greater than Amount'
    end
    errors
  end

  def payment_params
    params.permit(:amount, :min_payable_amount)
  end
end
