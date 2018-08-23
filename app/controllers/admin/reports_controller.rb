class Admin::ReportsController < Admin::BaseController

  def index
    @exams = Exam.all
    # @test = {name: "Mock Test 2018", marks: 180, date: '15 July 2018'}
    # @students = [
    #   {id: 1, name: 'Kapil Bhosale', batch: '12th Neet', marks: 160, rank: 1, correct: 80, wrong: 0},
    #   {id: 2, name: 'Deepak Jadhav', batch: '12th Neet', marks: 157, rank: 2, correct: 78, wrong: 0},
    #   {id: 3, name: 'kalpak Bhosale', batch: '12th Neet', marks: 151, rank: 3, correct: 90, wrong: 0},
    #   {id: 4, name: 'Akshay Mohite', batch: '12th Neet', marks: 139, rank: 4, correct: 90, wrong: 0},
    #   {id: 5, name: 'Deepak potdar', batch: '12th Neet', marks: 139, rank: 5, correct: 90, wrong: 0},
    #   {id: 6, name: 'Sachin chole', batch: '12th Neet', marks: 120, rank: 6, correct: 90, wrong: 0},
    #   {id: 7, name: 'sumit Joshi', batch: '12th Neet', marks: 119, rank: 7, correct: 90, wrong: 0},
    #   {id: 8, name: 'Amol Patil', batch: '12th Neet', marks: 119, rank: 8, correct: 90, wrong: 0},
    #   {id: 9, name: 'Somnath kada', batch: '12th Neet', marks: 111, rank: 9, correct: 90, wrong: 0},
    #   {id: 10, name: 'Kiran Kale', batch: '12th Neet', marks: 110, rank: 10, correct: 90, wrong: 0},
    #   {id: 11, name: 'Nilesh Rothe', batch: '12th Neet', marks: 110, rank: 11, correct: 90, wrong: 0},
    #   {id: 12, name: 'Arutwar krisha', batch: '12th Neet', marks: 100, rank: 12, correct: 90, wrong: 0},
    #   {id: 13, name: 'samadhan jadhav', batch: '12th Neet', marks: 99, rank: 13, correct: 90, wrong: 0},
    #   {id: 14, name: 'patil vishal', batch: '12th Neet', marks: 10, rank: 14, correct: 90, wrong: 0},
    #   {id: 15, name: 'more vittha', batch: '12th Neet', marks: 0, rank: 15, correct: 90, wrong: 0},
    # ]
  end

  def show
    @response = Reports::ShowExamReportService.new(params[:id], params[:q]).prepare_report
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
        @response[:student_exams].to_csv
      end
    end
  end

  private

  def set_flash
    unless @response[:status]
      flash[:error] = @response[:message]
    end
  end
end
