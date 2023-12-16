class Admin::BatchesController < Admin::BaseController
  before_action :check_permissions

  def index
    @batches = Batch.where(org: current_org, id: current_admin.batches&.ids).includes(:batch_group, :fees_templates).order(:created_at)
  end

  def new
    @batch = Batch.new
    @batch_groups = BatchGroup.where(org: current_org).order(:id).all
    @klasses = current_org.data['classes'] || []
    @fees_templates = FeesTemplate.where(org: current_org)
    @selected_templates = []
    @admins = Admin.where(org: current_org)
  end

  def create
    @response = Batches::AddBatchService.new(params[:batch], current_org, params[:batch_group_id], params[:klass], params[:branch]).call

    if @response[:status]
      current_admin.batches << @response[:batch]

      Admin.where(org_id: current_org.id).where(id: params[:batch][:admin_ids]).each do |admin|
        admin.batches << @response[:batch]
      end
    end

    set_flash
    redirect_to admin_batches_path
  end

  def disable
    batch = Batch.find_by(org: current_org, id: params[:batch_id])
    if batch.present?
      batch.students.find_each do |student|
        if student.batches.count == 1
          student.update!(disable: true, app_reset_count: student.app_reset_count + 1)
        else
          student.batches.delete(batch)
        end
      end
      batch.recount_disable
      flash[:success] = 'Students disabled, successfully.'
    else
      flash[:error] = 'Error in disabling Student App Login.'
    end
    redirect_to admin_batches_path
  end

  def show
    @batch = Batch.find_by(org: current_org, id: params[:id])
  end

  def edit
    @batch = Batch.find_by(org: current_org, id: params[:id])
    @batch_groups = BatchGroup.where(org: current_org).order(:id).all
    @klasses = current_org.data['classes'] || []
    @fees_templates = FeesTemplate.where(org: current_org)
    @selected_templates = @batch.fees_templates&.ids || []
    @admins = Admin.where(org: current_org)
  end

  def update
    if current_admin.roles.include? 'batch_edit'
      @response = Batches::UpdateBatchService.new(params[:id], params[:batch], params[:batch_group_id], params[:klass], params[:branch]).call
    else
      @response = {
        status: false,
        message: "You dont have permissions to update batches"
      }
    end

    set_flash
    redirect_to admin_batches_path
  end

  def destroy
    @response = Batches::DeleteBatchService.new(params[:id], current_org).call
    set_flash
    redirect_to admin_batches_path
  end

  def change_batches
    @student_data = {batches: Batch.where(org: current_org).all_batches}
  end

  def process_change_batches
    csv_file_path = params[:csv_file].tempfile.path
    batch_id = params[:batch_id]
    @total_count, @success_count = 0, 0

    CSV.open(csv_file_path, :row_sep => :auto, :encoding => 'ISO-8859-1', :col_sep => ",") do |csv|
      flash[:error] = "Invalid CSV" and redirect_to change_batches_admin_batches_path and return if csv.first.length != 4

      # [Roll Number, name, parent mobile number, student mobile number]
      csv.each do |row|
        @total_count += 1
        roll_number = row[0]&.strip
        parent_mobile = row[2]&.strip
        student_mobile = row[3]&.strip

        student = Student.find_by(roll_number: roll_number, parent_mobile: parent_mobile, student_mobile: student_mobile)
        next if student.blank?

        if params["remove-from-batch"] == "on"
          template_batch_ids = Batch.where(org_id: current_org.id).ids & BatchFeesTemplate.pluck(:batch_id).uniq
          StudentBatch.where(student: student).where.not(batch_id: template_batch_ids).delete_all
        end
        StudentBatch.create!(student: student, batch_id: batch_id)
        @success_count += 1
      end
    end
    flash[:notice] = "Student Batches Changed #{@success_count}/#{@total_count}"
    @student_data = {batches: Batch.where(org: current_org).all_batches}
    render 'change_batches'
  end

  def downoload_cet
    headers = ["id", "Roll Number", "Name", "Parent mobile", "Student mobile", "email", "gender", "center", "sub-center", "taluka", "Dist", "course", "rcc branch", "Board", "Reg Date"]

    map_ids = {}
    batch_ids = [params[:batch_id]]

    valid_student_ids = StudentBatch.where(batch_id: batch_ids).pluck(:student_id)
    valid_na_ids = Student.where(id: valid_student_ids).pluck(:new_admission_id).uniq

    Student.where(new_admission_id: valid_na_ids).find_each do |s|
      map_ids[s.new_admission_id] = s.roll_number
    end

    att_csv = CSV.generate(headers: true) do |writer|
      writer << headers
      NewAdmission.where(id: valid_na_ids).each do |na|
        writer << [
          na.id,
          map_ids[na.id],
          na.name,
          na.parent_mobile,
          na.student_mobile,
          na.email,
          na.gender,
          na.extra_data["set_center_11th"],
          na.extra_data["set_sub_center_11th"],
          na.extra_data["taluka"],
          na.extra_data["district"],
          na.course_type,
          na.rcc_branch,
          na.extra_data["board"],
          na.created_at.strftime('%Y-%m-%d')
        ]
      end
    end
    send_data att_csv, filename: "SET-#{Date.today}-#{params[:batch_id]}.csv"
  end

  private

  def batch_params
    params.require(:batch).permit(:name)
  end

  def set_flash
    key = @response[:status] ? :success : :warning
    flash[key] = @response[:message]
  end

  def check_permissions
    redirect_to '/404' unless current_admin.can_manage(:batches)
  end
end
