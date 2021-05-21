class Admin::StudentsController < Admin::BaseController
  ITEMS_PER_PAGE = 20

  def index
    @search = Student
      .where(org: current_org)
      .includes(:student_batches, :batches, :pending_fees)
      .where(batches: {id: current_admin.batches&.ids})

    if params[:q].present? && params[:q][:batch_id].present?
      @search = @search.where(batches: {id: params[:q][:batch_id]})
    end

    @search = @search.search(search_params)

    @students = @search.result.order(created_at: :desc)

    if request.format.html?
      @students = @students.page(params[:page]).per(params[:limit] || ITEMS_PER_PAGE)
    end

    @batches = Batch.where(org: current_org).all_batches

    @students_data = @students.includes(:batches, :pending_fees).order(created_at: :desc).map do |student|
      {
          roll_number: student.roll_number,
          batches: student&.batches&.each&.map(&:name).join(', '),
          name: student.name,
          email: student.email,
          raw_password: student.raw_password,
          parent_mobile: student.parent_mobile,
          student_mobile: student.student_mobile,
          pending_amount: student&.pending_fees.where(paid: false).last&.amount
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
    @batches = Batch.where(org: current_org, id: current_admin.batches&.ids).all_batches.order(:id)
    @batches_with_group = Batch.where(org: current_org, id: current_admin.batches&.ids).all_batches.order(:id).order(:id).group_by(&:batch_group_id)
    @batch_groups = BatchGroup.where(org: current_org).order(:id).order(:id).index_by(&:id)
    @student_data = {
      roll_number: Student.suggest_roll_number(current_org),
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
    @batches = Batch.where(org: current_org, id: current_admin.batches&.ids).all_batches.order(:id)
    @batches_with_group = Batch.where(org: current_org, id: current_admin.batches&.ids).all_batches.order(:id).group_by(&:batch_group_id)
    @batch_groups = BatchGroup.where(org: current_org).order(:id).order(:id).index_by(&:id)
    @student_data = {
      roll_number: Student.suggest_roll_number(current_org),
      batches: Batch.where(org: current_org, id: current_admin.batches&.ids).all_batches,
      categories: Category.all
    }
  end

  def update
    @response = Students::UpdateStudentService.new(params, student_params).update
    set_flash
    redirect_to admin_students_path
  end

  def progress_report
    @student = Student.find_by(id: params[:student_id])
    exams = Exam.includes(:batches).where(batches: { id: @student.batches.ids }).where(is_pr_generated: true)
    progress_report_data = ProgressReport.where(student_id: @student.id).order(exam_date: :desc)
    data = {}
    progress_report_data.each do |prd|
      key = "#{prd.exam_id || 0}-#{prd&.exam_name&.parameterize || 'default-exam'}"

      data[key] = {
        exam_date: prd.exam_date,
        present: true,
        data: {
          exam_date: prd.exam_date,
          is_imported: prd.is_imported,
          exam_name: prd.exam_name,
          data: prd.data.is_a?(Hash) ? prd.data : JSON.parse(prd.data || '{}'),
          percentage: prd.percentage,
          rank: prd.rank
        }
      }
    end
    exams.each do |exam|
      key = "#{exam.id || 0}-#{exam.name.parameterize}"
      data[key] ||= {
        exam_date: exam.show_exam_at,
        present: false,
        data: {
          exam_date: exam.show_exam_at,
          is_imported: false,
          exam_name: exam.name,
          data: {},
          percentage: 0,
          rank: nil
        }
      }
    end
    @data = Hash[data.sort_by{|k, v| v[:exam_date] || Date.today }.reverse].values
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
    redirect_to edit_admin_student_path(@student)
  end

  def disable
    @student = Student.find_by(id: params[:student_id], org: current_org)
    if @student.present?
      @student.update!(disable: true, app_reset_count: @student.app_reset_count + 1)
      flash[:success] = 'Student disabled, successfully.'
      @student.batches.each do |batch|
        batch.recount_disable
      end
    else
      flash[:error] = 'Error in disabling Student App Login.'
    end
    redirect_to edit_admin_student_path(@student)
  end

  def enable
    @student = Student.find_by(id: params[:student_id], org: current_org)
    if @student.present?
      @student.update!(disable: false)
      @student.batches.each do |batch|
        batch.recount_disable
      end
      flash[:success] = 'Student enabled, successfully.'
    else
      flash[:error] = 'Error in enabling Student App Login.'
    end
    redirect_to edit_admin_student_path(@student)
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

  def process_import_fees_due
    csv_file_path = params[:pending_fees_csv_file].tempfile.path

    CSV.open(csv_file_path, :row_sep => :auto, :encoding => 'ISO-8859-1', :col_sep => ",") do |csv|
      csv.each do |row|
        roll_number = row[0]&.strip
        parent_mobile = row[2]&.strip
        amount = row[3]&.strip&.to_s.to_i
        block_videos = (row[4]&.strip&.to_s&.downcase == 'yes')

        student = Student.find_by(org_id: current_org.id, roll_number: roll_number, parent_mobile: parent_mobile)
        next if student.blank?

        pending_fees_record = PendingFee.find_by(student_id: student.id, paid: false)
        if pending_fees_record.present?
          pending_fees_record.amount = amount
          pending_fees_record.block_videos = block_videos
          pending_fees_record.save
        else
          PendingFee.create(student_id: student.id, amount: amount, block_videos: block_videos)
        end
      end
    end
    @student_data = {batches: Batch.where(org: current_org).all_batches}
    flash[:notice] = "Student Fees Data imported"
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
      :rfid_card_number,
      :batches,
      :photo,
    )
  end

  def set_flash
    key = @response[:status] ? :success : :warning
    flash[key] = @response[:message]
  end
end
