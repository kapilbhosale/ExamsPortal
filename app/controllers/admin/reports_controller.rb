class Admin::ReportsController < Admin::BaseController

  def index
    @exams = Exam.where(org: current_org).all.order(id: :desc)
    @students_count_by_exam_id = StudentExam.where(exam: @exams).group(:exam_id).count
  end

  def generate_progress_report
    exam = Exam.find_by(id: params[:report_id], org: current_org)

    prepare_report(exam)

    flash[:success] = "Report Card generated, Do not Regenrate it."
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

  def prepare_report(exam)
    Reports::ExamCsvReportService.new(exam.id).prepare_report
    progress_report_data = {}

    # prepate report by deleting existing reports first.
    ProgressReport.where(exam_id: exam.id).delete_all
    StudentExamSummary.includes(:student_exam, :section).where({student_exams: {exam_id: exam.id}}).find_each do |ses|
      student_exam_key = "sid:#{ses.student_exam.student_id}-exam_id:#{exam.id}"
      progress_report_data[student_exam_key] ||= {
        exam_date: exam.show_exam_at,
        exam_name: exam.name,
        exam_id: exam.id,
        student_id: ses.student_exam.student_id,
        percentage: 0,
        data: {
          ses.section.name => {},
          total: { score: 0, total: 0 }
        }
      }

      total_score = ses.total_score
      if total_score.zero?
        exam_section = ExamSection.find_by(exam: exam, section: ses.section)
        total_score = exam_section.positive_marks * ses.no_of_questions
      end
      progress_report_data[student_exam_key][:data][ses.section.name] = { score: ses.score, total: total_score }
      progress_report_data[student_exam_key][:data][:total][:score] += ses.score
      progress_report_data[student_exam_key][:data][:total][:total] += total_score
      progress_report_data[student_exam_key][:percentage] += 100 * ses.score.to_f / total_score.to_f
    end
    ProgressReport.create(progress_report_data.values)
  end
end

exam_ids = []
StudentExamSummary.where.not(total_score: nil).includes(:student_exam).find_each do |ses|
  exam_ids << ses.student_exam.exam_id
end
exam_ids = exam_ids.uniq


Model.where("(data -> 'bar' -> 'baz' ->> 'qux') IS NOT NULL")
ProgressReport.where("(data -> 'total' ->> 'total') > 1000").limit(1)


ProgressReport.where("CAST((data -> 'total' ->> 'total') AS INT) > ?", 1000).pluck(:exam_id).uniq

def total_marks(exam)
  totals = {
    grand: 0
  }
  exam_sections = ExamSection.where(exam_id: exam.id).includes(:section).index_by(&:section_id)
  exam.questions.group(:section_id).count.each do |section_id, q_count|
    totals[:grand] += exam_sections[section_id].positive_marks * q_count
    totals[exam_sections[section_id].section.name] = exam_sections[section_id].positive_marks * q_count
  end
  totals
end

exam_totals_by_id = {}
Exam.all.each do |exam|
  exam_totals_by_id[exam.id] = total_marks(exam)
end