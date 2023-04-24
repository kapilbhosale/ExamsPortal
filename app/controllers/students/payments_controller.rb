# frozen_string_literal: true
require 'razorpay'

class Students::PaymentsController < ApplicationController
  # layout false, only: [:initiate_pay]
  skip_before_action :verify_authenticity_token
  def initiate_pay
    # Razorpay::Payment.fetch("123").capture({amount:5})
    @new_admission = NewAdmission.find_by(id: params[:id])
    if @new_admission.present?
      if dev_account?
        fees = (2 * 100)
      else
        fees = @new_admission.fees.to_f.to_i
        fees += 120 if @new_admission.student_id.blank?
        fees = (fees * 100)
      end

      # if @new_admission&.course&.name == 'foundation'
      #   Razorpay.setup(ENV.fetch('F_RZ_KEY_ID'), ENV.fetch('F_RZ_KEY_SECRET'))
      # end

      @order = Razorpay::Order.create({
        amount: fees,
        currency: 'INR',
        receipt: 'Payment Receipt',
        notes: {
          name: @new_admission.name,
          student_mobile: @new_admission.student_mobile,
          parent_mobile: @new_admission.parent_mobile,
          gender: @new_admission.gender,
          email: @new_admission.email,
          course_id: @new_admission.course_id,
          batch: @new_admission.batch,
          rcc_branch: @new_admission.rcc_branch
        }
      })

      @new_admission.update(rz_order_id: @order.id)
    else
      flash[:error] = "Error in processing your request, please try agian."
      redirect_back(fallback_location: '/new-admission')
    end
  end

  def authorize_payment
    if Razorpay::Utility.verify_payment_signature(payment_params.to_h)
      @new_admission = NewAdmission.find_by(rz_order_id: payment_params[:razorpay_order_id])
      if @new_admission.present?
        @new_admission.success!
        PaymentWorker.perform_async(@new_admission.id)
      end
    end
    render :confirm_payment
  end

  def process_payment
    order_id = params.dig(:payload, :payment, :entity, :order_id) || params.dig('payload', 'payment', 'entity', 'order_id')
    new_admission = NewAdmission.find_by(rz_order_id: order_id)
    if new_admission && new_admission.success?
      new_admission.payment_callback_data = params[:payment]
      new_admission.save
    end
  end

  private

  def payment_params
    params.permit(:razorpay_payment_id, :razorpay_order_id, :razorpay_signature)
  end

  def dev_account?
    @new_admission.student_mobile == '7588584810' &&
      @new_admission.parent_mobile == '7588584810' &&
      @new_admission.email == 'k@dev.io'
  end
end
