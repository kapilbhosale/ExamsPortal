class Admin::StudyPdfsController < Admin::BaseController
  #  pdf controller section
  def edit
    @er = StudyPdf.find_by(id: params[:id])
    batch_ids = BatchStudyPdf.where(exam_resource: @er).pluck(:batch_id)
    @batches = Batch.where(id: batch_ids)
  end

  def update
    er = ExamResource.find_by(id: params[:id])
    er.test_name = params[:exam_name]
    er.question_paper_link = params[:question_paper] if params[:question_paper].present?
    er.solution_paper_link = params[:solution_paper] if params[:solution_paper].present?
    er.save
    flash[:success] = "Test Updated, successfully"
    redirect_to admin_test_resources_path
  end

  def create
    study_pdf = StudyPdf.new
    if params[:exam_name].present?
      study_pdf.name = params[:exam_name]
      study_pdf.question_paper = params[:question_paper] if params[:question_paper].present?
      study_pdf.solution_paper = params[:solution_paper] if params[:solution_paper].present?
      study_pdf.pdf_type = ExamResource.pdf_types[params[:pdf_type]] if params[:pdf_type].present?
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
    redirect_to new_admin_android_app_path
  end

  def download_question_paper
    er = ExamResource.find_by(id: params[:test_resource_id])
    send_file er.question_paper_link.url, type: "application/pdf", x_sendfile: true
  end

  def download_solution_paper
    er = ExamResource.find_by(id: params[:test_resource_id])
    send_file er.solution_paper_link.url, type: "application/pdf", x_sendfile: true
  end

  def destroy
    er = ExamResource.find_by(id: params[:id])
    er.destroy if er.present?
    flash[:success] = "PDF deleted, successfully"
    redirect_to admin_test_resources_path
  end
end