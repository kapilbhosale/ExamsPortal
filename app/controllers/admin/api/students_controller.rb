class Admin::Api::StudentsController < Admin::Api::ApiController
  def index
    students = Student.where(org: current_org).where.not(rfid_card_number: [nil, ""]).includes(:batches).map do |student|
      {
        id: student.id,
        name: student.name,
        roll_number: student.roll_number,
        batches: student.batches.pluck(:name).join(', '),
        parent_mobile: student.parent_mobile,
        rfid_card_number: student.rfid_card_number
      }
    end
    render json: students, status: :ok
  end
end
