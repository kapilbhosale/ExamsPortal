class Admin::GenresController < Admin::BaseController
  def index
    @genres = Genre.where(org_id: current_org.id)

    @search = Genre.where(org_id: current_org.id).all.order(id: :desc)

    if params[:q].present?
      if params[:q][:subject_id].present?
        @search = @search.where(subject_id: params[:q][:subject_id])
      end

      if params[:q][:name].present?
        @search = @search.where("name ILIKE ?", "%#{params[:q][:name]}%")
      end
    end

    @search = @search.search(search_params)
    @genres = @search.result.order(created_at: :desc)
    @subjects = Subject.where(org: current_org).all
  end

  def new
    @genre = Genre.new
    @subjects = Subject.where(org_id: current_org.id)
  end

  def edit
    @genre = Genre.find_by(id: params[:id], org_id: current_org.id)
    @subjects = Subject.where(org_id: current_org.id)
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

  private

  def search_params
    return {} if params[:q].blank?

    search_term = params[:q][:name]&.strip
    { name_cont: search_term }
  end
end
