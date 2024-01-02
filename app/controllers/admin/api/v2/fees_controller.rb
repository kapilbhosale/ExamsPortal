class Admin::Api::V2::FeesController < Admin::Api::V2::ApiController
  before_action :authorize_request, only: [:create_fees_transaction]

  def details
    student = Student.find_by(org_id: current_org.id, id: params[:student_id])
    # adding this token so, one request is processed only once.
    fees_transaction_token = SecureRandom.uuid
    REDIS_CACHE.set("fees-token-#{student.id}", fees_transaction_token)

    current_template_id = nil
    existing_template = FeesTransaction.student_fees_template_data(current_org.id, student.id)

    if existing_template.present?
      fees_templates = Array.wrap(existing_template)
      current_template_id = existing_template['id']
    else
      fees_templates = student.batches.map(&:fees_templates)
    end

    # todo::kalpak, how if discount is present but not applied.
    discount = Discount.valid_discount.find_by(id: student.data['discount_id'])
    academic_year = student.batches.joins(:fees_templates).first&.edu_year || FeesTransaction::CURRENT_ACADEMIC_YEAR
    last_year_waive_off = CourseChangeEntry.where(student_id: student.id).order(:id)&.last&.pending_amount

    data = {
      student: {
        id: student.id,
        roll_number: student.roll_number,
        name: student.name,
        batches: student.batches.joins(:fees_templates).pluck(:name).join(', '),
        student_mobile: student.student_mobile,
        parent_mobile: student.parent_mobile,
        record_book: "Yes",
        academic_year: academic_year,
        current_template_id: current_template_id,
        fees_transaction_token: fees_transaction_token,
        rcc_batch: student.data["rcc_batch"],
        strict_discount: ['exams', 'rcc'].include?(current_org.subdomain), #true, #current_org.rcc?,
        valid_discount: discount.present?,
        discount: discount&.amount&.to_i || 0,
        discount_type: discount&.type_of_discount,
        last_year_waive_off: last_year_waive_off
      },
      templates: fees_templates&.flatten || []
    }

    render json: data
  end

  def payment_history
    student = Student.find_by(org_id: current_org.id, id: params[:student_id])
    @transactions = FeesTransaction.current_year.includes(:admin).where(org_id: current_org.id, student_id: student.id).order(created_at: :desc)
    @discounts = {}
    Discount.used_discount.where(roll_number: student.roll_number, parent_mobile: student.parent_mobile).each do |discount|
      @discounts[discount.amount.to_f] = {
        type: discount.type_of_discount,
        comment: discount.comment,
        amount: discount.amount.to_f,
        approved_by: discount.approved_by,
        date: discount.updated_at.strftime("%d-%b-%Y")
      }
    end
  end

  def create_fees_transaction
    if params[:ref].present?
      response = Fees::CreatePastOnlineFees.new(current_org, current_admin, create_fee_transaction_params).create
    else
      response = Fees::CreateFeesTransaction.new(current_org, current_admin, create_fee_transaction_params).create
    end

    render json: response[:data] and return if response[:status]

    render json: response[:message], status: :unprocessable_entity
  end

  private

  def create_fee_transaction_params
    params.require(:fee).permit(
      :student_id,
      :comment,
      :mode_of_payment,
      :template_id,
      :next_due_date,
      :fees_transaction_token,
      :ref,
      fees_details: {})
  end
end
