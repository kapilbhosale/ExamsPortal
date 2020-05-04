class Admin::StudyPdfsController < Admin::BaseController
  #  pdf controller section
  def edit
    @study_pdf = StudyPdf.find_by(id: params[:id])

  end

  def update
    study_pdf = StudyPdf.find_by(id: params[:id])
    study_pdf.name = params[:exam_name]
    study_pdf.question_paper_link = params[:question_paper] if params[:question_paper].present?
    study_pdf.solution_paper_link = params[:solution_paper] if params[:solution_paper].present?
    study_pdf.pdf_type = (params[:pdf_type].to_i || 1) if params[:pdf_type].present?
    if study_pdf.save
      if params[:batches].present?
        BatchStudyPdf.where(study_pdf: study_pdf).delete_all
        params[:batches].each do |batch_id|
          BatchStudyPdf.create(study_pdf: study_pdf, batch_id: batch_id)
        end
      end
      flash[:success] = "PDF Edited, successfully"
    else
      flash[:error] = "Error in Editing PDF.."
    end
    redirect_to admin_android_apps_path
  end

  def create
    study_pdf = StudyPdf.new
    if params[:exam_name].present?
      study_pdf.name = params[:exam_name]
      study_pdf.question_paper = params[:question_paper] if params[:question_paper].present?
      study_pdf.solution_paper = params[:solution_paper] if params[:solution_paper].present?
      study_pdf.pdf_type = (params[:pdf_type].to_i || 1) if params[:pdf_type].present?
      study_pdf.org = current_org
      if study_pdf.save
        if params[:batches].present?
          params[:batches].each do |batch_id|
            BatchStudyPdf.create(study_pdf: study_pdf, batch_id: batch_id)
          end
        end
        flash[:success] = "PDF added, successfully"
      else
        flash[:error] = "Error in adding PDF.."
      end
    end

    redirect_to admin_android_apps_path
  end

  def destroy
    spdf = StudyPdf.find_by(id: params[:id])
    spdf.destroy if spdf.present?
    flash[:success] = "PDF deleted, successfully"
    redirect_to admin_android_apps_path
  end
end