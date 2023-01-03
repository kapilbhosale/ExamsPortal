class Admin::Api::V2::FeesController < Admin::Api::V2::ApiController

  def details
    student = Student.find_by(id: params[:student_id])
    data = {
      student: {
        id: student.id,
        roll_number: student.roll_number,
        name: student.name,
        batches: student.batches.pluck(:name).join(", "),
        student_mobile: student.student_mobile,
        parent_mobile: student.parent_mobile,
        record_book: "Yes",
        academic_year: "2023-24",
      },
      template: {
        id: 101,
        name: "Template 01",
        fees: [
          {head: "Tution Fees", amount: 40_000, cgst: 9, sgst: 9},
          {head: "Book Fees", amount: 10_000, cgst: 2.5, sgst: 2.5},
          {head: "Other Fees", amount: 0, cgst: 5, sgst: 5}
        ]
      },
      payment_history: [
        {
          id: 102,
          receipt_no: 300,
          date: "10/11/2022",
          amount_paid: 20_000,
          amount_remaining: 40_000,
          total_discount: 0,
        },
        {
          id: 102,
          receipt_no: 300,
          date: "10/11/2022",
          amount_paid: 20_000,
          amount_remaining: 40_000,
          total_discount: 0,
        }
      ]
    }

    render json: data
  end

  # {
  #   student_id: 1,
  #   comment: "",
  #   next_due_date: "1212",
  #   received_by_id: 12,
  #   template_id: 101,
  #   payment: {
  #     "Tution Fees" => { paid: 10_000, discount: 0, fees: 1400, cgst: 180, sgst: 180 },
  #     "Book Fees" => { paid: 2_000, discount: 0, fees: 1400, cgst: 180, sgst: 180 },
  #   }
  # }
  def create_fees_transaction
    # create FeesTransaction
    render json: {
      receipt_number: 1002,
      created_at: DateTime.now.strftime("%d-%b-%Y %I:%M%p"),
    }
  end
end
