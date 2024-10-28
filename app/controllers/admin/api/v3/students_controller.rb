class Admin::Api::V3::StudentsController < Admin::Api::V2::ApiController

  def index
    render json: { students: Student.first(20) }
  end

  private
end