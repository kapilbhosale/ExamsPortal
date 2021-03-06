class Admin::ReportsController < Admin::BaseController
  ITEMS_PER_PAGE = 20

  def index
    @exams = Exam.where(org: current_org).includes(:batches, :exam_sections, :exam_batches).where(batches: {id: current_admin.batches&.ids}).all.order(id: :desc)
    @students_count_by_exam_id = StudentExam.where(exam: @exams).group(:exam_id).count

    @exams = @exams.page(params[:page]).per(params[:limit] || ITEMS_PER_PAGE)
  end

  def generate_progress_report
    exam = Exam.find_by(id: params[:report_id], org: current_org)
    if exam.present?
      flash[:success] = "Report Card will get generated in background, Do not Regenrate it."
      ProgressReportWorker.perform_async(exam.id)
      REDIS_CACHE.set("pr-report-exam-id-#{exam.id}", true, { ex: 1.hour })
    else
      flash[:error] = "Invalid Exam, please try again."
    end

    redirect_to admin_reports_path
  end

  def show
    exam = Exam.find_by(id: params[:id], org: current_org)
    @response = Reports::ExamCsvReportService.new(params[:id]).prepare_report

    respond_to do |format|
      format.html do
        set_flash
      end
      format.pdf do
        render pdf: "student information",
               template: "admin/reports/show.pdf.erb",
               locals: {students: @response[:student_exams]},
               footer: { font_size: 9, left: DateTime.now.strftime("%d-%B-%Y %I:%M%p"), right: 'Page [page] of [topage]' }
      end
      format.csv do
        send_data @response, filename: "#{exam.name}_result.csv"
      end
    end
  end

  def exam_detailed_report
    exam = Exam.find_by(id: params[:report_id], org: current_org)
    @response = Reports::DetailedExamCsvReportService.new(exam.id).prepare_report

    respond_to do |format|
      format.csv do
        send_data @response, filename: "#{exam.name}_detailed_student_analysis_report.csv"
      end
    end
  end

  def student_progress
    student = Student.find_by(id: params[:id], org: current_org)
  end

  private

  def set_flash
    unless @response[:status]
      flash[:error] = @response[:message]
    end
  end

end
