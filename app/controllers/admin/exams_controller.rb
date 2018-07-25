class Admin::ExamsController < Admin::BaseController

  def index
    @exams = Exam.all.order(id: :desc)
  end

  def new

  end

  def create
    @exam = Exam.new(exam_params)
    if @exam.save
      redirect_to admin_exams_path
    else
      render 'new'
    end
  end

  private
  def exam_params
    params.permit(:name, :description, :no_of_questions, :time_in_minutes)
  end
end
