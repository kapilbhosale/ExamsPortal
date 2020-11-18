class PaymentWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'critical', retry: 1

  def perform(new_admission_id)
    new_admission = NewAdmission.find_by(id: new_admission_id)
    if new_admission.student_id.present?
      student = Student.find_by(id: new_admission.student_id)
      if student.present?
        PaymentTransaction.create(
          student_id: student.id,
          amount: new_admission.payment_callback_data['Total Amount'].to_f,
          reference_number: new_admission.payment_id,
          new_admission_id: new_admission.id
        )

        # remove due information on successful payment.
        pending_fees = PendingFee.find_by(student_id: student.id, paid: false, amount: new_admission.fees)
        if pending_fees.present?
          pending_fees.paid = true
          pending_fees.reference_no = @new_admission.id
          pending_fees.save
        end

        batches = Batch.get_batches(new_admission.rcc_branch, new_admission.course, new_admission.batch)
        if batches.present?
          # student.batches.destroy_all
          student.new_admission_id = new_admission.id
          student.save
          student.batches << batches
          # student.roll_number = suggest_online_roll_number(Org.first, batches, true)
          if new_admission.batch == 'repeater'
            student.roll_number = Student.suggest_rep_online_roll_number
            student.suggested_roll_number = Student.suggest_rep_online_roll_number
          else
            student.roll_number = Student.suggest_tw_online_roll_number
            student.suggested_roll_number = Student.suggest_tw_online_roll_number
          end
          student.api_key = student.api_key + '+1'
          student.app_login = false
          student.save
        end
        student.send_sms(true)
      end
    else
      pay_transaction = PaymentTransaction.find_by(
        reference_number: new_admission.payment_id,
        new_admission_id: new_admission.id
      ) rescue nil

      if pay_transaction.blank?
        std = Student.add_student(new_admission)
        new_admission.student_id = std.id
        new_admission.save
        PaymentTransaction.create(
          student_id: std.id,
          amount: new_admission.payment_callback_data['Total Amount'].to_f,
          reference_number: new_admission.payment_id,
          new_admission_id: new_admission.id
        ) rescue nil
      end
    end
  end
end
