class Admin::ReportsController < Admin::BaseController

  def index
    @exams = Exam.where(org: current_org).includes(:batches).where(batches: {id: current_admin.batches&.ids}).all.order(id: :desc)
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
