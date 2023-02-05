
class Admin::SubjectsController < Admin::BaseController
  before_action :check_permissions

  def index
    @subjects = Subject.where(org: current_org).all
  end

  def new
    @subject = Subject.new
  end

  def create
    if params[:subject][:name].present?
      @subject = Subject.create(
        name: params[:subject][:name].strip,
        org: current_org,
        klass: params[:subject][:klass].strip
      )
      if @subject.persisted?
        flash[:success] = "Subject Added successfully."
      else
        flash[:errors] = @subject.errors.full_messages.join(", ")
      end
    else
      flash[:errors] = "Subject name must exists"
    end
    redirect_to admin_subjects_path
  end

  def edit
    @subject = Subject.find_by(org: current_org, id: params[:id])
  end

  def update
    @subject = Subject.find_by(org: current_org, id: params[:id])
    if @subject && params[:subject][:name]
      @subject.name = params[:subject][:name].strip
      @subject.klass = params[:subject][:klass].strip
      if @subject.save
        flash[:success] = "Subject updated successfully."
      else
        flash[:errors] = @subject.errors.full_messages.join(",")
      end
    else
      flash[:errors] = "Please provide name to update"
    end
    redirect_to admin_subjects_path
  end

  def destroy
    @subject = Subject.find_by(id: params[:id], org: current_org)
    if @subject
      @subject.destroy!
      flash[:success] = "Subject deleted successfully."
    else
      flash[:errors] = "Subject not found"
    end
    redirect_to admin_subjects_path
  end

  private

  def subject_params
    params.require(:subject).permit(:name)
  end

  def set_flash
    key = @response[:status] ? :success : :warning
    flash[key] = @response[:message]
  end

  def check_permissions
    redirect_to '/404' unless current_admin.can_manage(:subjects)
  end
end
