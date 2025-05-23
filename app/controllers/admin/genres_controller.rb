class Admin::GenresController < Admin::BaseController
  def index
    if params[:filter] && params[:filter].keys.length == 1
      if params[:filter]["pdf"].present?
        @pdf = true
        @search = Genre.where(org_id: current_org.id).where('study_pdfs_count > 0').order(id: :desc)
      else
        @video = true
        @search = Genre.where(org_id: current_org.id).where('video_lectures_count > 0').order(id: :desc)
      end
    else
      @pdf, @video = true, true
      @search = Genre.where(org_id: current_org.id).order(id: :desc)
    end

    if params[:q].present?
      if params[:q][:subject_id].present?
        @search = @search.where(subject_id: params[:q][:subject_id])
      end

      if params[:q][:name].present?
        @search = @search.where("name ILIKE ?", "%#{params[:q][:name]}%")
      end
    end

    @search = @search.search(search_params)
    @genres = @search.result.order(created_at: :desc).includes(:subject)
    @genres = @genres.page(params[:page]).per(params[:limit] || ITEMS_PER_PAGE)
    @subjects = Subject.where(org: current_org).all

    if params[:student_id].present?
      @student = Student.find_by(id: params[:student_id])

      @student_folder_access_data = {}
      svfs = StudentVideoFolder.where(student_id: @student.id).index_by(&:genre_id)

      student_active_date = @student.created_at

      # genre_ids = VideoLecture.includes(:batches, :subject).where(batches: {id: @student.batches}).pluck(:genre_id).uniq
      genre_ids = VideoLecture.includes(:subject).pluck(:genre_id).uniq
      @genres = @genres.where(id: genre_ids).includes(:subject)
      @genres.each do |genre|
        # next unless genre.hidden

        svf = svfs[genre.id]
        if svf.present?
          @student_folder_access_data[genre.id] = {
            days: (svf.show_till_date.to_date - Date.today).to_i,
            date: svf.show_till_date.strftime('%Y-%m-%d')
          }
        else
          vl_to_consider = genre&.video_lectures&.order(:id)&.last
          genre_date = vl_to_consider&.publish_at || vl_to_consider&.created_at.to_date || genre.created_at.to_date

          if student_active_date <= genre_date
            @student_folder_access_data[genre.id] =  {
              days: 0,
              date: genre.updated_at.strftime('%Y-%m-%d')
            }
          else
            @student_folder_access_data[genre.id] =  {
              days: (student_active_date.to_date + 30.days - Date.today).to_i,
              date: (student_active_date.to_date + 30.days).strftime('%Y-%m-%d')
            }
          end
        end
      end
    end
  end

  def new
    @genre = Genre.new
    @subjects = Subject.where(org_id: current_org.id)
  end

  def edit
    @genre = Genre.find_by(id: params[:id], org_id: current_org.id)
    @subjects = Subject.where(org_id: current_org.id)

    video_lecture_ids = VideoLecture.where(genre_id: @genre.id).pluck(:id)
    @selected_batch_ids = BatchVideoLecture.where(video_lecture_id: video_lecture_ids).pluck(:batch_id).uniq

    @batches_with_group = Batch.where(org: current_org, id: current_admin.batches&.ids).all_batches.order(:id).group_by(&:batch_group_id)
    @batch_groups = BatchGroup.where(org: current_org).order(:id).index_by(&:id)
  end

  def create
    if params[:name].present?
      Genre.create!(name: params[:name], org_id: current_org.id, subject_id: params[:subject_id])
      flash[:success] = "Genre added successfully.."
    else
      flash[:error] = "Error in creating genre.."
    end
    redirect_to admin_genres_path
  end

  def update
    @genre = Genre.find_by(id: params[:id], org_id: current_org.id)
    if params[:subject_id].present?
      @genre.update(name: params[:name], subject_id: params[:subject_id])
    else
      @genre.update(name: params[:name])
    end

    if params[:assign_batches] == 'yes'
      @genre.batch_assigned = true
      @genre.save
      # video_lecture_ids = VideoLecture.where(genre_id: @genre.id).pluck(:id)
      # already_selected_batch_ids = BatchVideoLecture.where(video_lecture_id: video_lecture_ids).pluck(:batch_id).uniq
      input_batch_ids = params[:batches].map(&:to_i)
      # new_batch_ids = input_batch_ids - already_selected_batch_ids
      if input_batch_ids.present?
        BatchVideoLecture.where(video_lecture_id: @genre.video_lectures.ids).destroy_all
        @genre.video_lectures.each do |vl|
          vl.batches << Batch.where(id: input_batch_ids)
        end
      end
    else
      @genre.batch_assigned = false
      @genre.save
    end

    flash[:success] = "Genre updated successfully.."
    redirect_to admin_genres_path
  end

  def hide
    genre = Genre.find_by(id: params[:genre_id], org_id: current_org.id)
    genre.hidden = true
    genre.save
    VideoLecture.where(genre_id: genre.id).update_all(enabled: false)
    flash[:success] = "Action successful"
    redirect_to admin_genres_path
  end

  def show
    genre = Genre.find_by(id: params[:genre_id], org_id: current_org.id)
    genre.hidden = false
    genre.save
    VideoLecture.where(genre_id: genre.id).update_all(enabled: true)
    flash[:success] = "Action successful"
    redirect_to admin_genres_path
  end

  def destroy
    genre = Genre.find_by(id: params[:id])
    genre.destroy
    flash[:success] = "Genre removed successfully.."
    redirect_to admin_genres_path
  end

  def student_folder_access
    svf = StudentVideoFolder.find_by(genre_id: folder_access_params[:genre_id], student_id: folder_access_params[:student_id])
    if svf.present?
      svf.update(show_till_date: folder_access_params[:show_till_date])
    else
      svf = StudentVideoFolder.create(folder_access_params)
    end
    render json: {} and return if svf.errors.blank?

    render json: { error: svf.errors.full_messages.join(', ') }, status: :unprocessable_entity
  end

  private

  def search_params
    return {} if params[:q].blank?

    search_term = params[:q][:name]&.strip
    { name_cont: search_term }
  end

  def folder_access_params
    params.permit(:show_till_date, :genre_id, :student_id)
  end
end
