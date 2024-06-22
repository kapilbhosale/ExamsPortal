class FeeTransactionError < StandardError; end

module Fees
  class CreateHeadlessFeesTransaction
    attr_reader :create_params, :current_org, :current_admin, :last_transaction
    attr_writer :fees_data

    def initialize(current_org, current_admin, create_params)
      @create_params = create_params
      @current_org = current_org
      @current_admin = current_admin
      @fees_data = {}
      @last_transaction = FeesTransaction.where(student_id: create_params[:student_id]).order(:created_at).last
    end

    def create
      validate_request
      create_payment_data

      ActiveRecord::Base.transaction do
        @fees_transaction = FeesTransaction.new do |ft|
          ft.org_id = current_org.id
          ft.student_id = create_params[:student_id]
          ft.academic_year = FeesTransaction::CURRENT_ACADEMIC_YEAR
          ft.comment = create_params[:comment]
          ft.mode = create_params[:mode_of_payment]
          ft.next_due_date = create_params[:next_due_date]

          @fees_data.delete(:paid_amount)
          ft.paid_amount = payment_params[:amount]

          ft.remaining_amount = @fees_data.delete(:remaining_amount)
          ft.remaining_amount = last_transaction.remaining_amount
          @fees_data.delete(:discount_amount)
          ft.discount_amount = 0

          totals = @fees_data.delete(:totals)
          ft.payment_details[:template] = nil
          ft.payment_details[:totals] = totals
          ft.payment_details[:paid] = @fees_data
          ft.received_by_admin_id = current_admin&.id
          ft.received_by = current_admin&.name || current_admin&.email
          ft.is_headless = true
        end
        @fees_transaction.save
      end

      if @fees_transaction.errors.blank?
        REDIS_CACHE.del("fees-token-#{create_params[:student_id]}")
        return { status: true, data: {
          id: @fees_transaction.id,
          receipt_number: @fees_transaction.receipt_number,
          created_at: @fees_transaction.created_at.strftime("%d-%b-%Y %I:%M%p"),
          received_by: @fees_transaction.received_by,
          day_token: @fees_transaction.token_of_the_day
        }}
      end

      return { status: false, message: @fees_transaction.errors.full_messages.join(', ')}
    rescue FeeTransactionError, ActiveRecord::RecordInvalid => ex
      return { status: false, message: ex.message }
    end

    private

    def payment_params
      create_params[:fees_details][:headlessData].permit(:head, :amount)
    end

    def create_payment_data
      total_gst = 18.0
      fees =  payment_params[:amount].to_f / ((100 + total_gst) / 100.0).round(2)

      cgst = fees * (9.0 / 100.0).round(2)
      sgst = fees * (9.0 / 100.0).round(2)

      total_paid = payment_params[:amount].to_f
      total_cgst = cgst
      total_sgst = sgst
      total_fees = fees

      @fees_data[payment_params[:head]] = {
        paid: total_paid,
        discount: 0,
        fees: fees,
        cgst: cgst,
        sgst: sgst
      }

      @fees_data[:paid_amount] = total_paid
      @fees_data[:discount_amount] = 0
      @fees_data[:remaining_amount] = last_transaction.remaining_amount

      @fees_data[:totals] = {
        cgst: total_cgst,
        sgst: total_sgst,
        fees: total_fees,
        paid: total_paid,
        discount: 0
      }
    end

    def validate_request
      raise FeeTransactionError, 'not permitted' unless current_admin.roles.include?('payments')
      raise FeeTransactionError, 'Invalid payment amounts' unless valid_payments?
      if REDIS_CACHE.get("fees-token-#{create_params[:student_id]}") != create_params[:fees_transaction_token]
        raise FeeTransactionError, 'Form already submitted, please try after page refresh'
      end

    end

    def is_number? string
      true if Float(string) rescue false
    end

    def valid_payments?
      return false if payment_params[:head].blank? || payment_params[:amount].blank? || !is_number?(payment_params[:amount]) || payment_params[:amount].to_i <= 0

      true
    end
  end
end
