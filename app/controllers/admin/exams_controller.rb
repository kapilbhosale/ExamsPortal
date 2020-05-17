class Admin::ExamsController < Admin::BaseController
  before_action :sections, only: [:new, :create]
  def index
    @exams = Exam
      .where(org: current_org)
      .includes(:batches)
      .order(id: :desc)
      .page(params[:page])
      .per(params[:limit] || ITEMS_PER_PAGE)
  end

  def new
    @batches = Batch.where(org: current_org).all_batches
    @sections = Section.jee.all.select(:id, :name, :description)
  end

  def create
    @response = Exams::AddExamService.new(params, current_org).create
    set_flash
    if @response[:status]
      redirect_to admin_exams_path
    else
      @batches = Batch.where(org: current_org).all_batches
      @sections = Section.jee.all.select(:id, :name, :description)
      render 'new'
    end
  end

  def show
    exam = Exam.where(org: current_org).includes(questions: :options).find_by(id: params[:id])
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
    @response = Exams::DeleteExamService.new(params[:id], current_org).delete
    set_flash
    redirect_to admin_exams_path
  end

  def edit
    @exam = Exam.find_by(id: params[:id], org: current_org)
    @batches = Batch.where(org: current_org).all_batches
    respond_to do |format|
      format.html do
      end
      format.js do
      end
    end
  end

  def update
    @response = Exams::UpdateExamService.new(params, current_org).update
    set_flash
    redirect_to admin_exams_path
  end

  private

  def sections
    @sections = Section.non_jee.all.select(:id, :name)
  end

  def set_flash
    key = @response[:status] ? :success : :warning
    flash[key] = @response[:message]
  end
end
