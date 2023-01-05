class FeeTransactionError < StandardError; end

module Fees
  class CreateFeesTransaction
    attr_reader :create_params, :current_org, :fees_template
    attr_writer :fees_tempalte_data, :fees_data

    def initialize(current_org, create_params)
      @create_params = create_params
      @current_org = current_org
      @fees_template = FeesTemplate.find_by(id: create_params[:template_id] )
      @fees_tempalte_data, @fees_data = {}, {}
      create_fees_tempalte_data
    end

    def create
      validate_request
      fees_transaction = nil
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
          ft.payment_details[:template] = template_data
          ft.payment_details[:paid] = @fees_data
        end
        @fees_transaction.save
      end

      if @fees_transaction.errors.blank?
        return { status: true, data: {
          id: @fees_transaction.id,
          receipt_number: @fees_transaction.receipt_number,
          created_at: @fees_transaction.created_at.strftime("%d-%b-%Y %I:%M%p")
          }}
      end

      return { status: false, message: @fees_transaction.errors.full_messages.join(', ')}
    rescue FeeTransactionError, ActiveRecord::RecordInvalid => ex
      return { status: false, message: ex.message }
    end

    private
    def validate_request
      raise FeeTransactionError, 'No fees heads' if create_params[:fees_details].to_h.blank?
      raise FeeTransactionError, 'Fees Template not found, try again' if fees_template.blank?
      raise FeeTransactionError, 'Fees Template heads are not mathcing' unless matching_heads?
      raise FeeTransactionError, 'Invalid payment amounts' unless valid_payments?
    end

    def matching_heads?
      template_heads = fees_template.heads.map do |row|
        row['head']
      end

      input_heads = create_params[:fees_details].keys

      template_heads.sort == input_heads.sort
    end

    def valid_payments?
      create_params[:fees_details].to_h.each do |_, val|
        return false unless val['pay'].to_i.to_s == val['pay']
        return false if val['pay'].to_i < 0
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

      create_params[:fees_details].to_h.each do |key, val|
        @fees_tempalte_data[key]

        cgst = val[:pay].to_f * (@fees_tempalte_data[key]['cgst'].to_f/100.0)
        sgst = val[:pay].to_f * (@fees_tempalte_data[key]['sgst'].to_f/100.0)
        fees = val[:pay].to_f - (cgst + sgst)

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
    end

    def template_data
      @fees_template.slice(:id, :name, :heads)
    end
  end
end
