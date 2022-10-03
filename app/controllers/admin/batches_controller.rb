class Admin::BatchesController < Admin::BaseController
  before_action :check_permissions

  def index
    @batches = Batch.where(org: current_org, id: current_admin.batches&.ids).includes(:batch_group).all.order(:id)
  end

  def new
    @batch = Batch.new
    @batch_groups = BatchGroup.where(org: current_org).order(:id).all
  end

  def create
    @response = Batches::AddBatchService.new(params[:batch], current_org, params[:batch_group_id]).call

    if @response[:status]
      Admin.where(org_id: current_org.id).each do |admin|
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
  end

  def update
    @response = Batches::UpdateBatchService.new(params[:id], params[:batch], params[:batch_group_id]).call
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
      flash[:error] = "Invalid CSV" and redirect back if csv.first.length != 4

      # [Roll Number, name, parent mobile number, student mobile number]
      csv.each do |row|
        @total_count += 1
        roll_number = row[0]&.strip
        parent_mobile = row[2]&.strip
        student_mobile = row[3]&.strip

        student = Student.find_by(roll_number: roll_number, parent_mobile: parent_mobile, student_mobile: student_mobile)
        next if student.blank?

        StudentBatch.where(student: student).delete_all
        StudentBatch.create!(student: student, batch_id: batch_id)
        @success_count += 1
      end
    end
    flash[:notice] = "Student Batches Changed #{@success_count}/#{@total_count}"
    @student_data = {batches: Batch.where(org: current_org).all_batches}
    render 'change_batches'
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
