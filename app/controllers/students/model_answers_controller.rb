class Students::ModelAnswersController < Students::BaseController
  before_action :authenticate_student!
  def show
    model_ans_response = Students::ModelAnswersService.new(current_student.id, params[:id]).call
    if model_ans_response[:status]
      @data = model_ans_response[:data]
    else
      @errors = model_ans_response[:message]
    end
  end

  def model_ans
    render json: Students::ModelAnswersService.new(current_student.id, params[:id]).call
  end
end
