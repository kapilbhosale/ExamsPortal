class Admin::StudentsController < Admin::BaseController
  ITEMS_PER_PAGE = 20

  def index
    @search = Student
      .where(org: current_org)
      .includes(:student_batches, :batches).joins(:batches)

    if params[:q].present? && params[:q][:batch_id].present?
      @search = @search.where(batches: {id: params[:q][:batch_id]})
    end

    @search = @search.search(search_params)

    @students = @search.result.order(created_at: :desc)

    if request.format.html?
      @students = @students.page(params[:page]).per(params[:limit] || ITEMS_PER_PAGE)
    end

    @batches = Batch.where(org: current_org).all_batches

    @students_data = @students.includes(:batches).order(:roll_number).map do |student|
      {
          roll_number: student.roll_number,
          batches: student&.batches&.each&.map(&:name).join(', '),
          name: student.name,
          email: student.email,
          raw_password: student.raw_password,
          parent_mobile: student.parent_mobile,
          student_mobile: student.student_mobile,
      }
    end

    params.permit(:q, :limit)
    respond_to do |format|
      format.html do
      end
      format.pdf do
        render pdf: "StudentList.pdf",
               template: "admin/students/index.pdf.erb",
               locals: { students: @students},
               footer: { font_size: 9, left: DateTime.now.strftime("%d-%B-%Y %I:%M%p"), right: 'Page [page] of [topage]' }
      end
      format.csv do
        students_csv = CSV.generate(headers: true) do |csv|
          csv << ['Roll Number', 'Student Name', 'Student mobile', 'Parent mobile', 'Email', 'password', 'Batch']

          @students_data.each do |student|
            csv << [
                student[:roll_number],
                student[:name],
                student[:student_mobile],
                student[:parent_mobile],
                student[:email],
                student[:raw_password],
                student[:batches]
            ]
          end
        end

        send_data students_csv, filename: 'StudentList.csv'
      end
    end
  end

  def new
    @student = Student.new
    @student_data = {
      roll_number: Student.suggest_roll_number(current_org),
      batches: Batch.where(org: current_org).all_batches,
      categories: Category.all
    }
  end

  def create
    @response = Students::AddStudentService.new(student_params, params[:student][:batches], current_org).call
    set_flash
    redirect_to admin_students_path
  end

  def show
    @student = Student.find_by(id: params[:id])
  end

  def edit
    @student = Student.find_by(id: params[:id], org: current_org)
    @student_data = {roll_number: Student.suggest_roll_number(current_org), batches: Batch.where(org: current_org).all_batches, categories: Category.all}
  end

  def update
    @response = Students::UpdateStudentService.new(params, student_params).update
    set_flash
    redirect_to admin_students_path
  end

  def progress_report
    
  end

  def reset_login
    @student = Student.find_by(id: params[:student_id], org: current_org)
    if @student.present?
      @student.update!(
        app_login: false,
        is_laptop_login: false,
        deviceUniqueId: nil,
        deviceName: nil,
        manufacturer: nil,
        brand: nil,
        app_reset_count: @student.app_reset_count + 1
      )
      flash[:success] = 'Student App Login Reset, successfully.'
    else
      flash[:error] = 'Error in resetting Student App Login.'
    end
    redirect_to admin_students_path
  end

  def destroy
    @response = Students::DeleteStudentService.new(params[:id], current_org).call
    set_flash
    redirect_to admin_students_path
  end

  def import
    @student_data = {batches: Batch.where(org: current_org).all_batches}
  end

  def process_import
    csv_file_path = params[:csv_file].tempfile.path
    batch_id = params[:batch_id]
    import_service = Students::ImportService.new(csv_file_path, batch_id, current_org)
    @response = import_service.import
    flash[:notice] = "Student imported - #{@response}"
    render 'import'
  end

  private

  def search_params
    return {} if params[:q].blank?

    search_term = params[:q][:name_and_roll_number]&.strip

    # to check if input is number or string
    if search_term.to_i.to_s == search_term
      return { roll_number_eq: search_term } if search_term.length <= 7
      return { parent_mobile_cont: search_term }
    end

    { name_cont: search_term }
  end

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
