class Admin::ExamsController < Admin::BaseController

  def index
    @exams = Exam.all.order(id: :desc)
  end

  def new
    @sections = Section.all.select(:id, :name)
  end

  def create
    @sections = Section.all.select(:id, :name)
    @response = Exams::AddExamService.new(params).create
    set_flash
    if @response[:status]
      redirect_to admin_exams_path
    else
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

  private

  def set_flash
    key = @response[:status] ? :success : :warning
    flash[key] = @response[:message]
  end
end

# Imgur
# client_id : 5b8da04bb57e141
# secret : ad9a52bcab65dbd79b68c2b98b53eec9c1fbecb6
