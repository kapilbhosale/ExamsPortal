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
          amount: new_admission.fees.to_f,
          reference_number: new_admission.payment_id,
          new_admission_id: new_admission.id
        )

        # remove due information on successful payment.
        pending_fees = PendingFee.find_by(student_id: student.id, paid: false, amount: new_admission.fees)
        if pending_fees.present?
          pending_fees.paid = true
          pending_fees.reference_no = new_admission.id
          pending_fees.save
        end

        if new_admission.extra_data['is_set'] == true || new_admission.extra_data['is_set'] == 'true'
          student.new_admission_id = new_admission.id
          student.save
          student.send_sms
        else
          batches = Batch.get_batches(new_admission.rcc_branch, new_admission.course, new_admission.batch, new_admission)
          student.new_admission_id = new_admission.id
          student.save
          if batches.present?
            batches_to_add = batches - student.batches
            if batches_to_add.present?
              if (student&.batches&.ids & MAPPING.keys).present?
                student.batches.destroy_all
              end
              student.batches << batches_to_add

              suggested_rn = RollNumberSuggestor.suggest_roll_number(@new_admission.batch)
              student.roll_number = suggested_rn
              student.suggested_roll_number = suggested_rn

              student.api_key = student.api_key + '+1'
              student.app_login = false
              student.save
            end
          end
          student.send_sms(true)
        end
      end
    else
      pay_transaction = PaymentTransaction.find_by(
        reference_number: new_admission.payment_id,
        new_admission_id: new_admission.id
      ) rescue nil

      if pay_transaction.blank? && new_admission.default?
        new_admission.started!
        std = Student.add_student(new_admission)
        new_admission.student_id = std.id
        new_admission.save
        PaymentTransaction.create(
          student_id: std.id,
          amount: new_admission.fees.to_f,
          reference_number: new_admission.payment_id,
          new_admission_id: new_admission.id
        ) rescue nil
        new_admission.done!
      end
    end

    Batch.re_count_students_all_batches
  end
end
