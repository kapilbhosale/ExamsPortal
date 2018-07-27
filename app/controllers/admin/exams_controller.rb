class Admin::ExamsController < Admin::BaseController

  def index
    @exams = Exam.all.order(id: :desc)
  end

  def new
  end

  def create
    @exam = Exam.new(exam_params)
    if @exam.save
      extract_zip(params[:questions_zip].tempfile) if params[:questions_zip].present?
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

# Imgur
# client_id : 5b8da04bb57e141
# secret : ad9a52bcab65dbd79b68c2b98b53eec9c1fbecb6
