class Admin::Api::V2::FeesController < Admin::Api::V2::ApiController

  def details
    student = Student.find_by(id: params[:student_id])
    data = {
      student: {
        id: student.id,
        roll_number: student.roll_number,
        name: student.name,
        batches: student.batches.pluck(:name).join(", ")
      },
      template: {
        id: 101,
        name: "Template 01",
        fees: [
          {head: "Tution Fees", amount: 40_000},
          {head: "Book Fees", amount: 10_000},
          {head: "Other Fees", amount: 10_000}
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
end
