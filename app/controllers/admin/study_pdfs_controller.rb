class Admin::StudyPdfsController < Admin::BaseController
  ITEMS_PER_PAGE = 20
  #  pdf controller section
  def index
    @study_pdfs = StudyPdf.includes(:study_pdf_type, :org)
      .where(org: current_org)
      .includes(:batches, :batch_study_pdfs)
      .where(batches: {id: current_admin.batches&.ids})
      .all
      .order(id: :desc)
      .page(params[:page])
      .per(params[:limit] || ITEMS_PER_PAGE)
  end
  
  def new
    @batches_with_group = Batch.where(org: current_org, id: current_admin.batches&.ids).all_batches.group_by(&:batch_group_id)
    @batch_groups = BatchGroup.where(org: current_org).index_by(&:id)
    @study_pdf_types = StudyPdfType.where(org: current_org)
  end

  def edit
    @study_pdf = StudyPdf.find_by(org: current_org, id: params[:id])
    @batches_with_group = Batch.where(org: current_org, id: current_admin.batches&.ids).all_batches.group_by(&:batch_group_id)
    @batch_groups = BatchGroup.where(org: current_org).index_by(&:id)
    @study_pdf_types = StudyPdfType.where(org: current_org)
  end

  def update
    study_pdf = StudyPdf.find_by(org: current_org, id: params[:id])
    if study_pdf.present?
      errors = validate_pdf_data(params)
      if errors.blank?
        study_pdf.name = params[:pdf_name]
        study_pdf.question_paper_link = params[:question_paper] if params[:question_paper].present?
        study_pdf.solution_paper_link = params[:solution_paper] if params[:solution_paper].present?
        study_pdf.study_pdf_type_id = params[:pdf_type_id]
        if study_pdf.save
          if params[:batches].present?
            BatchStudyPdf.where(study_pdf: study_pdf).delete_all
            params[:batches].each do |batch_id|
              BatchStudyPdf.create(study_pdf: study_pdf, batch_id: batch_id)
              clear_cache(batch_id)
            end
          end
          flash[:success] = "PDF Edited, successfully"
        else
          flash[:error] = "Error in Editing PDF.."
        end
      else
        flash[:error] = errors.join(", ")
      end
    else
      flash[:error] = "PDF not found, please try agian."
    end
    redirect_to "#{admin_android_apps_path}#pdfs"
  end

  def create
    study_pdf = StudyPdf.new
    errors = validate_pdf_data(params)
    if errors.blank?
      study_pdf.name = params[:pdf_name]
      study_pdf.question_paper = params[:question_paper] if params[:question_paper].present?
      study_pdf.solution_paper = params[:solution_paper] if params[:solution_paper].present?
      study_pdf.study_pdf_type_id = params[:pdf_type_id]
      study_pdf.org = current_org
      if study_pdf.save
        if params[:batches].present?
          params[:batches].each do |batch_id|
            BatchStudyPdf.create(study_pdf: study_pdf, batch_id: batch_id)
            clear_cache(batch_id)
          end
        end
        study_pdf.send_push_notifications
        flash[:success] = "PDF added, successfully"
      else
        flash[:error] = "Error in adding PDF.."
      end
    else
      flash[:error] = errors.join(", ")
    end

    redirect_to "#{admin_android_apps_path}#pdfs"
  end

  def validate_pdf_data(params)
    return ["PDF type not found"] if params[:pdf_name].blank?

    study_pdf_type_id = params[:pdf_type_id]
    study_pdf_type = StudyPdfType.find_by(id: study_pdf_type_id)
    return ["PDF type not found"] if study_pdf_type.blank?

    if study_pdf_type.single_link?
      return ["PDF file not uploaded, pleases add file and try again"] if params[:solution_paper].blank?
    else
      if params[:solution_paper].blank? && params[:question_paper].blank?
        return ["PDF file not uploaded, pleases add atleast one files and try again"]
      end
    end

    return nil
  end

  def destroy
    spdf = StudyPdf.find_by(org: current_org, id: params[:id])
    spdf.destroy if spdf.present?
    flash[:success] = "PDF deleted, successfully"

    redirect_to "#{admin_android_apps_path}#pdfs"
  end

  def clear_cache(batch_id)
    cache_key = "BatchStudyPdf-batch-id-#{batch_id}"
    REDIS_CACHE.del(cache_key)
  end
end