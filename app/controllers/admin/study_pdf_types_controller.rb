class Admin::StudyPdfTypesController < Admin::BaseController
  def index
    @study_pdf_types = StudyPdfType.where(org_id: current_org.id)
  end

  def new
    @study_pdf_type = StudyPdfType.new
  end

  def edit
    @study_pdf_type = StudyPdfType.find_by(id: params[:id], org_id: current_org.id)
  end

  def create
    if params[:name].present?
      StudyPdfType.create!(
        name: params[:name],
        pdf_type: StudyPdfType.pdf_types[params[:pdf_type]],
        org_id: current_org.id
      )
      flash[:success] = "Pdf Type added successfully.."
    else
      flash[:error] = "Error in creating Pdf Type.."
    end
    redirect_to admin_study_pdf_types_path
  end

  def update
    @study_pdf_type = StudyPdfType.find_by(id: params[:id], org_id: current_org.id)
    @study_pdf_type.update(
      name: params[:name],
      pdf_type: StudyPdfType.pdf_types[params[:pdf_type]],
    )
    flash[:success] = "Pdf Type updated successfully.."
    redirect_to admin_study_pdf_types_path
  end

  def destroy
    study_pdf_type = StudyPdfType.find_by(id: params[:id])
    study_pdf_type.destroy
    flash[:success] = "Pdf Type removed successfully.."
    redirect_to admin_study_pdf_types_path
  end
end
