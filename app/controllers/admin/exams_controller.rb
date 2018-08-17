class Admin::ExamsController < Admin::BaseController
  before_action :sections, only: [:new, :create]
  def index
    @exams = Exam.includes(:batches).all.order(id: :desc)
  end

  def new
    @batches = Batch.all_batches
  end

  def create
    @response = Exams::AddExamService.new(params).create
    set_flash
    if @response[:status]
      redirect_to admin_exams_path
    else
      @batches = Batch.all_batches
      render 'new'
    end
  end

  def show
    exam = Exam.find_by(id: params[:id])
    if exam.present?
      @questions_by_section = exam.questions.group_by(&:section_id)
      @sections_by_id = Section.all.index_by(&:id)
      @all_styles = exam.questions.collect {|x| x.css_style}.join(' ')
    else
      flash[:error] = "Invalid exam id passed"
      render :index
    end
  end

  def change_question_answer
  end

  def destroy
    @response = Exams::DeleteExamService.new(params[:id]).delete
    set_flash
    redirect_to admin_exams_path
  end

  def edit
    @exam = Exam.find_by(id: params[:id])
    @batches = Batch.all_batches
    respond_to do |format|
      format.html do
      end
      format.js do
      end
    end
  end

  def update
    @response = Exams::UpdateExamService.new(params).update
    set_flash
    redirect_to admin_exams_path
  end

  private

  def sections
    @sections = Section.all.select(:id, :name)
  end

  private

  def set_flash
    key = @response[:status] ? :success : :warning
    flash[key] = @response[:message]
  end
end
