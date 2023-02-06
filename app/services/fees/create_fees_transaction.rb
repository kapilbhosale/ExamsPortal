class FeeTransactionError < StandardError; end

module Fees
  class CreateFeesTransaction
    attr_reader :create_params, :current_org, :fees_template, :current_admin
    attr_writer :fees_tempalte_data, :fees_data

    def initialize(current_org, current_admin, create_params)
      @create_params = create_params
      @current_org = current_org
      @current_admin = current_admin
      @fees_template = FeesTemplate.find_by(id: create_params[:template_id] )
      @fees_tempalte_data, @fees_data = {}, {}
      sanitiz_input_payments
      create_fees_tempalte_data
    end

    def create
      validate_request

      ActiveRecord::Base.transaction do
        @fees_transaction = FeesTransaction.new do |ft|
          ft.org_id = current_org.id
          ft.student_id = create_params[:student_id]
          ft.academic_year = FeesTransaction::CURRENT_ACADEMIC_YEAR
          ft.comment = create_params[:comment]
          ft.mode = create_params[:mode_of_payment]
          ft.next_due_date = create_params[:next_due_date]

          ft.paid_amount = @fees_data.delete(:paid_amount)
          ft.discount_amount = @fees_data.delete(:discount_amount)
          ft.remaining_amount = @fees_data.delete(:remaining_amount)
          totals = @fees_data.delete(:totals)

          ft.payment_details[:template] = template_data
          ft.payment_details[:totals] = totals
          ft.payment_details[:paid] = @fees_data
          ft.received_by_admin_id = current_admin&.id
          ft.received_by = current_admin&.name || current_admin&.email
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

    def sanitiz_input_payments
      @sanitized_input_payments = {}
      @paying_per_head = {}
      create_params[:fees_details].to_h.each do |head, values|
        @sanitized_input_payments[head] = {
          pay: values['pay'].to_f,
          discount: values['discount'].to_f
        }
        @paying_per_head[head] = values['pay'].to_f + values['discount'].to_f
      end
    end

    def validate_request
      raise FeeTransactionError, 'No fees heads' if @sanitized_input_payments.blank?
      raise FeeTransactionError, 'Fees Template not found, try again' if fees_template.blank?
      raise FeeTransactionError, 'Fees Template heads are not mathcing' unless matching_heads?
      raise FeeTransactionError, 'Invalid payment amounts' unless valid_payments?
      valid_max_payments_per_head?
      if REDIS_CACHE.get("fees-token-#{create_params[:student_id]}") != create_params[:fees_transaction_token]
        raise FeeTransactionError, 'Form already submitted, please try after page refresh'
      end

    end

    def matching_heads?
      template_heads = fees_template.heads.map do |row|
        row['head']
      end

      input_heads = create_params[:fees_details].keys
      (input_heads - template_heads).blank?
    end

    def valid_max_payments_per_head?
      student_template = FeesTransaction.student_fees_template_data(current_org.id, create_params[:student_id])
      template_to_validate = student_template.present? ? student_template : fees_template.attributes

      template_to_validate.dig('heads').each do |row|
        if @paying_per_head[row['head']] && @paying_per_head[row['head']] > row['amount']
          raise FeeTransactionError, "Invalid Amount for '#{row['head']}'"
        end
      end
    end

    def is_number? string
      true if Float(string) rescue false
    end

    def valid_payments?
      @sanitized_input_payments.each do |_, val|
        return false unless is_number?(val[:pay])
        return false if val[:pay].to_f.negative?
      end
      true
    end

    def create_fees_tempalte_data
      total_tempalte_amount = 0
      fees_template&.heads&.each do |row|
        @fees_tempalte_data[row['head']] = row
        total_tempalte_amount += row['amount']
      end

      student_transactions = FeesTransaction.current_year.where(student_id: create_params[:student_id])
      total_paid_till_date = student_transactions.sum(:paid_amount)
      total_discount_till_date = student_transactions.sum(:discount_amount)

      total_paid = 0
      total_fees = 0
      total_cgst = 0
      total_sgst = 0
      total_discount = 0
      remaining = 0

      @sanitized_input_payments.each do |key, val|
        @fees_tempalte_data[key]
        total_gst = @fees_tempalte_data[key]['cgst'].to_f + @fees_tempalte_data[key]['sgst'].to_f
        fees = val[:pay].to_f / ((100 + total_gst) / 100.0).round(2)

        cgst = fees * (@fees_tempalte_data[key]['cgst'].to_f / 100.0).round(2)
        sgst = fees * (@fees_tempalte_data[key]['sgst'].to_f / 100.0).round(2)

        total_paid += val[:pay].to_f
        total_cgst += cgst
        total_sgst += sgst
        total_fees += fees
        total_discount += val[:discount].to_f

        @fees_data[key] = {
          paid: val[:pay].to_f,
          discount: val[:discount].to_f,
          fees: fees,
          cgst: cgst,
          sgst: sgst
        }
      end

      @fees_data[:paid_amount] = total_paid
      @fees_data[:discount_amount] = total_discount
      @fees_data[:remaining_amount] = total_tempalte_amount - (total_paid_till_date + total_discount_till_date + total_paid + total_discount)

      @fees_data[:totals] = {
        cgst: total_cgst,
        sgst: total_sgst,
        fees: total_fees,
        paid: total_paid,
        discount: total_discount
      }
    end

    def template_data
      @fees_template.slice(:id, :name, :heads)
    end
  end
end
