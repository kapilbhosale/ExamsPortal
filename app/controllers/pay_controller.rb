class PayController < ApplicationController
  layout false, only: [:show]
  before_action :set_current_org
  attr_reader :current_org

  require 'razorpay'
  skip_before_action :verify_authenticity_token

  def show
    @student = nil
    @payment_link = MicroPayment.find_by(link: params[:slug])
    if @payment_link.blank?
      @payment_link = MicroPayment.find_or_create_by(
        link: "for-all-#{current_org.id}",
        amount: 30_000,
        min_payable_amount: 10_000,
        org_id: current_org.id
      )
      @payment_link.batches << Batch.where(org_id: current_org.id) if @payment_link.batches.blank?
    end
  end

  def create
    @errors = []
    @payment_link = MicroPayment.find_by(id: params[:id])
    if params[:amount].to_i < @payment_link.min_payable_amount
      @errors << "Invalid amount, minimum amount to pay must be - #{@payment_link.min_payable_amount}"
    end

    parent_mobile = params[:parent_mobile]
    student_mobile = params[:student_mobile]

    if parent_mobile.blank? || student_mobile.blank?
      @errors << 'Invalid parent or student mobile'
    end

    if @errors.blank?
      student_found = false
      student = Student.find_by(
      {
        parent_mobile: parent_mobile,
        student_mobile: student_mobile,
        org_id: current_org.id
      })

      if student
        unless student.batches.ids.include?(params[:batch].to_i)
          student.batches << Batch.find_by(id: params[:batch])
        end
        student_found = true
      else
        suggested_rn = RollNumberSuggestor.suggest_roll_number('pay_adm')
        roll_number = suggested_rn

        email = "#{roll_number}-#{parent_mobile}@#{current_org.subdomain}.in"
        student = Student.find_or_initialize_by(email: email)
        student.roll_number = roll_number
        student.suggested_roll_number = roll_number
        student.name = params[:name]
        student.mother_name = '-'
        student.gender = params[:gender] == 'male' ? 0 : 1
        student.student_mobile = student_mobile
        student.parent_mobile = parent_mobile
        student.category_id = 1
        student.password = parent_mobile
        student.raw_password = parent_mobile
        student.org_id = current_org.id
      end

      @order = Razorpay::Order.create({
        amount: (params[:amount].to_i * 100),
        currency: 'INR',
        receipt: 'Payment Receipt',
        notes: {
          name: student.name,
          student_mobile: student.student_mobile,
          parent_mobile: student.parent_mobile,
          gender: student.gender,
          email: student.email
        }
      })

      if student_found
        @student_payment = StudentPayment.create(
          student_id: student.id,
          micro_payment_id: @payment_link.id,
          amount: params[:amount].to_i,
          rz_order_id: @order.id
        )
      else
        @student_payment = StudentPayment.create(
          micro_payment_id: @payment_link.id,
          amount: params[:amount].to_i,
          rz_order_id: @order.id,
          raw_data: {
            student: student.attributes.slice("email", "roll_number", "suggested_roll_number", "name", "mother_name", "gender", "student_mobile", "parent_mobile", "category_id", "password", "raw_password", "org_id"),
            batch_id: params[:batch]
          }.to_json
        )
      end

      @student = student
      @org = current_org
      @batch = Batch.find_by(id: params[:batch])
    else
      render 'show'
    end
  end

  def process_pay
    order_id = params.dig(:payload, :payment, :entity, :order_id) || params.dig('payload', 'payment', 'entity', 'order_id')
    @student_payment = StudentPayment.find_by(rz_order_id: order_id)
    @student = @student_payment.student || JSON.parse(@student_payment.raw_data)['student'] rescue nil
    batch_id = JSON.parse(@student_payment.raw_data)['batch_id'] rescue nil
    @batch = Batch.find(batch_id) rescue nil
    render :confirm_pay
  end

  def auth_pay
    if Razorpay::Utility.verify_payment_signature(payment_params.to_h)
      student_payment = StudentPayment.find_by(rz_order_id: payment_params[:razorpay_order_id])
      if student_payment.present?
        student_payment.success!
        student_params = JSON.parse(student_payment.raw_data)['student']
        batch_id = JSON.parse(student_payment.raw_data)['batch_id']
        student_params['password'] = student_params['parent_mobile']
        student = Student.create(student_params)
        @batch = Batch.find(batch_id)
        student.batches << @batch if student
        student_payment.student_id = student.id
        student_payment.save
        @student_payment = student_payment
        @student = student
        render :confirm_pay and return
      end
    end
    render json: {status: 'ok 101'} and return
  end

  def set_current_org
    @current_org ||= Org.find_by(subdomain: request.subdomain)
  end

  private

  def payment_params
    params.permit(:razorpay_payment_id, :razorpay_order_id, :razorpay_signature)
  end
end
