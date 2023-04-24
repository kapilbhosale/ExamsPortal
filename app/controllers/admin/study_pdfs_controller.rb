class Admin::StudyPdfsController < Admin::BaseController
  before_action :check_permissions

  ITEMS_PER_PAGE = 20
  
  def index
    @search = StudyPdf.includes(:subject, :genre, :batches).where(org: current_org).where(batches: {id: current_admin.batches&.ids}).all.order(id: :desc)

    if params[:q].present?
      if params[:q][:subject_id].present?
        @search = @search.where(subject_id: params[:q][:subject_id])
      end

      if params[:q][:genre_id].present?
        @genre = Genre.find_by(org: current_org, id: params[:q][:genre_id])
        @search = @search.where(genre_id: params[:q][:genre_id])
      end
    end

    @search = @search.search(search_params)
    @study_pdfs = @search.result.order(created_at: :desc)

    if request.format.html?
      @study_pdfs = @study_pdfs.page(params[:page]).per(params[:limit] || ITEMS_PER_PAGE)
    end
  end

  def new
    @genre = Genre.find_by(org: current_org, id: params[:q][:genre_id])
    @batches_with_group = Batch.where(org: current_org, id: current_admin.batches&.ids).all_batches.order(:id).group_by(&:batch_group_id)
    @batch_groups = BatchGroup.where(org: current_org).order(:id).index_by(&:id)
    @pdf_types = StudyPdfType.pdf_types
  end

  def edit
    @study_pdf = StudyPdf.find_by(org: current_org, id: params[:id])
    @batches_with_group = Batch.where(org: current_org, id: current_admin.batches&.ids).all_batches.order(:id).group_by(&:batch_group_id)
    @batch_groups = BatchGroup.where(org: current_org).order(:id).index_by(&:id)
    @pdf_types = StudyPdfType.pdf_types
    @genres = Genre.where(org_id: current_org.id).order('name')
    @subjects = Subject.where(org_id: current_org.id).order('name')
  end

  def update
    study_pdf = StudyPdf.find_by(org: current_org, id: params[:id])
    if study_pdf.present?
      errors = validate_pdf_data(params)
      if errors.blank?
        study_pdf.name = params[:pdf_name]
        study_pdf.question_paper = params[:question_paper] if params[:question_paper].present?
        study_pdf.solution_paper = params[:solution_paper] if params[:solution_paper].present?
        study_pdf.pdf_type = StudyPdf.pdf_types[params[:pdf_type]]

        # Below two line sare redundent, need to remove once app shifted completely on android side.
        study_pdf_type = StudyPdfType.find_or_create_by(org: current_org, name: @genre.name, pdf_type: study_pdf.pdf_type)
        study_pdf.study_pdf_type_id = study_pdf_type.id
        study_pdf.genre_id = @genre.id
        study_pdf.subject_id = @genre.subject.id

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
    redirect_to admin_genres_path
  end

  def create
    study_pdf = StudyPdf.new
    errors = validate_pdf_data(params)
    if errors.blank?
      study_pdf.name = params[:pdf_name]
      study_pdf.question_paper = params[:question_paper] if params[:question_paper].present?
      study_pdf.solution_paper = params[:solution_paper] if params[:solution_paper].present?

      study_pdf.pdf_type = StudyPdf.pdf_types[params[:pdf_type]]

      # Below two line sare redundent, need to remove once app shifted completely on android side.
      study_pdf_type = StudyPdfType.find_or_create_by(org: current_org, name: @genre.name, pdf_type: study_pdf.pdf_type)
      study_pdf.study_pdf_type_id = study_pdf_type.id
      study_pdf.genre_id = @genre.id
      study_pdf.subject_id = @genre.subject.id

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

    redirect_to admin_genres_path
  end

  def validate_pdf_data(params)
    return ["PDF file not found"] if params[:pdf_name].blank?

    genre_id = params[:genre_id]
    @genre = Genre.find_by(org: current_org, id: genre_id)
    return ["PDF type not found"] if @genre.blank?

    if params[:action] == 'create'
      if params[:pdf_type] == "single_link"
        return ["PDF file not uploaded, pleases add file and try again"] if params[:solution_paper].blank?
      elsif params[:solution_paper].blank? && params[:question_paper].blank?
        return ["PDF file not uploaded, pleases add atleast one files and try again"]
      end
    end
  end

  def destroy
    spdf = StudyPdf.find_by(org: current_org, id: params[:id])
    spdf.destroy if spdf.present?
    flash[:success] = "PDF deleted, successfully"

    redirect_to "#{admin_android_apps_path}#pdfs"
  end


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

  def clear_cache(batch_id)
    cache_key = "BatchStudyPdf-batch-id-#{batch_id}"
    REDIS_CACHE.del(cache_key)
  end

  def check_permissions
    redirect_to '/404' unless current_admin.can_manage(:pdfs)
  end
end