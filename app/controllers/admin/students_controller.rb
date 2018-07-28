class Admin::StudentsController < Admin::BaseController

  def index
    @search = Student.includes(:student_batches).includes(:batches).search(params[:q])
    @students = @search.result.order(created_at: :asc)&.page(params[:page])&.per(params[:limit] || 10)
    params.permit(:q, :limit)
    respond_to do |format|
      format.html do
      end
      format.pdf do
        render pdf: "student information",
               template: "admin/students/index.pdf.erb",
               locals: {students: @students},
               footer: { font_size: 9, left: DateTime.now.strftime("%d-%B-%Y %I:%M%p"), right: 'Page [page] of [topage]' }
      end
    end
  end

  def new
    @student = Student.new
    @student_data = {roll_number: Student.suggest_roll_number, batches: Batch.all_batches, categories: Category.all}
  end

  def create
    @response = Students::AddStudentService.new(student_params, params[:student][:batches]).call
    set_flash
    redirect_to admin_students_path
  end

  def show
    @student = Student.find_by(id: params[:id])
  end

  def edit
    @student = Student.find_by(id: params[:id])
    @student_data = {roll_number: Student.suggest_roll_number, batches: Batch.all_batches, categories: Category.all}
  end

  def update
    @response = Students::UpdateStudentService.new(params, student_params).call
    set_flash
    redirect_to admin_students_path
  end

  def destroy
    @response = Students::DeleteStudentService.new(params[:id]).call
    set_flash
    redirect_to admin_students_path
  end

  private

  def student_params
    params.require(:student).permit(
      :roll_number,
      :name,
      :mother_name,
      :date_of_birth,
      :gender,
      :ssc_marks,
      :student_mobile,
      :parent_mobile,
      :category_id,
      :address,
      :college,
      :batches,
      :photo,
    )
  end

  def set_flash
    key = @response[:status] ? :success : :warning
    flash[key] = @response[:message]
  end
end
