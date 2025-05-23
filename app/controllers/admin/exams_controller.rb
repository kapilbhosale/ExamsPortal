class Admin::ExamsController < Admin::BaseController
  before_action :sections, only: [:new, :create]
  before_action :check_permissions

  ITEMS_PER_PAGE = 20
  def index
    @exams = Exam
      .where(org: current_org)
      .includes(:batches, :exam_batches)
      .where(batches: {id: current_admin.batches&.ids})
      .order(id: :desc)
      .page(params[:page])
      .per(params[:limit] || ITEMS_PER_PAGE)
  end

  def new
    @batches_with_group = Batch.where(org: current_org, id: current_admin.batches&.ids).all_batches.order(:id).group_by(&:batch_group_id)
    @batch_groups = BatchGroup.where(org: current_org).order(:id).index_by(&:id)
    @sections = Section.jee.all.select(:id, :name, :description)
  end

  def create
    @response = Exams::AddExamService.new(params, current_org).create
    set_flash
    if @response[:status]
      redirect_to admin_exams_path
    else
      @batches_with_group = Batch.where(org: current_org, id: current_admin.batches&.ids).all_batches.order(:id).group_by(&:batch_group_id)
      @batch_groups = BatchGroup.where(org: current_org).order(:id).index_by(&:id)
      @sections = Section.jee.all.select(:id, :name, :description)
      render 'new'
    end
  end

  def show
    @exam = Exam.where(org: current_org).includes(questions: :options).find_by(id: params[:id])
    if @exam.present?
      @questions_by_section = @exam.questions.order(:id).group_by(&:section_id)
      @sections_by_id = Section.all.index_by(&:id)
      @all_styles = @exam.questions.collect {|x| x.css_style}.join(' ')
    else
      flash[:error] = "Invalid exam id passed"
      render :index
    end
  end

  def re_evaluate_exam
    exam = Exam.find_by(id: params[:exam_id])
    if exam.present?
      if exam.show_exam_at.present? && Time.current >= (exam.show_exam_at + (exam.time_in_minutes + 15).minutes)
        ses_sync_by_student_ids = StudentExamSync.where(exam_id: exam.id).index_by(&:student_id)
        StudentExam.where(exam_id: exam.id).each do |student_exam|
          ses_sync = ses_sync_by_student_ids[student_exam.student_id]
          if ses_sync.present?
            Students::SyncService.new(student_exam.student_id, exam.id, ses_sync.sync_data).call
            StudentExamSummary.where(student_exam_id: student_exam.id).destroy_all
            StudentExamScoreCalculator.new(student_exam.id).calculate
          end
        end

        # re-generate PR report
        exam.prepare_report

        flash[:success] = 'Exam Scores updated successfully..!'
        redirect_back(fallback_location: admin_exams_path)
      else
        flash[:success] = 'Can not re-evaluate exam, Make changes after its completely finished.'
        redirect_back(fallback_location: admin_exams_path)
      end
    else
      flash[:error] = 'No Exam Found, please try again.'
      redirect_back(fallback_location: admin_exams_path)
    end
  end

  def change_question_answer
    if params[:option_ids].blank?
      flash[:error] = 'Atleast one option must be slected'
      redirect_back(fallback_location: admin_exams_path) and return
    end
    question = Question.find_by(id: params[:question_id])

    if question.exams.pluck(:org_id).first == current_org.id
      if params[:is_input].present?
        option = question.options.first
        option.data = params[:option_ids][params[:is_input]]
        option.save
      else
        question.options.pluck(:id, :is_answer)
        question.options.update_all(is_answer: false)
        question.options.where(id: params[:option_ids]).update_all(is_answer: true)
      end
      flash[:success] = 'Options updated successfully..!'
      redirect_back(fallback_location: admin_exams_path)
    else
      flash[:error] = 'Cannot update this question, invalid org'
      redirect_back(fallback_location: admin_exams_path)
    end
  end

  def destroy
    @response = Exams::DeleteExamService.new(params[:id], current_org).delete
    set_flash
    redirect_to admin_exams_path
  end

  def edit
    @exam = Exam.find_by(id: params[:id], org: current_org)
    @batches_with_group = Batch.where(org: current_org, id: current_admin.batches&.ids).all_batches.order(:id).group_by(&:batch_group_id)
    @batch_groups = BatchGroup.where(org: current_org).order(:id).index_by(&:id)
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

  def create_section
    if params[:section_name].present?
      Section.find_or_create_by(name: params[:section_name], is_jee: true)
      flash[:success] = 'Section Added, please re-create exam.'
    else
      flash[:error] = 'Section cannot be added, please try again.'
    end
    redirect_to new_admin_exam_path
  end

  private

  def sections
    @sections = Section.non_jee.all.select(:id, :name)
  end

  def set_flash
    key = @response[:status] ? :success : :warning
    flash[key] = @response[:message]
  end

  def check_permissions
    redirect_to '/404' unless current_admin.can_manage(:exams)
  end

end
