class Admin::ExamsController < Admin::BaseController

  def index
    @exams = Exam.all.order(id: :desc)
  end

  def new
  end

  def create
    @response = Exams::AddExamService.new(params).create
    set_flash
    if @response[:status]
      redirect_to admin_exams_path
    else
      render 'new'
    end
  end

  def show
    @exam = Exam.find_by(id: params[:id])
  end

  def change_question_answer

  end

  private

  def set_flash
    key = @response[:status] ? :success : :warning
    flash[key] = @response[:message]
  end
end

# Imgur
# client_id : 5b8da04bb57e141
# secret : ad9a52bcab65dbd79b68c2b98b53eec9c1fbecb6
