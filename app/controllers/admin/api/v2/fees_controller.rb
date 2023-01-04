class Admin::Api::V2::FeesController < Admin::Api::V2::ApiController

  def details
    student = Student.find_by(id: params[:student_id])
    fees_templates = student.batches.map(&:fees_templates)

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
      templates: fees_templates&.flatten || [],
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
  #   comment: "",\
  #   mode_of_payment: ""
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
    response = Fees::CreateFeesTransaction.new().create
    
    render json: {
      receipt_number: 1002,
      created_at: DateTime.now.strftime("%d-%b-%Y %I:%M%p"),
    }
  end

  private
  def create_fee_transaction_params
    params.require(:fee).permit(
      :student_id,
      :comment,
      :mode_of_payment,
      :template_id,
      fees_details: {})
  end
end
