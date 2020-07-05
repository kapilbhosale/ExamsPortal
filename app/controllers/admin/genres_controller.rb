class Admin::GenresController < Admin::BaseController
  def index
    @genres = Genre.where(org_id: current_org.id)
  end

  def new
    @genre = Genre.new
  end

  def edit
    @genre = Genre.find_by(id: params[:id], org_id: current_org.id)
  end

  def create
    if params[:name].present?
      Genre.create!(name: params[:name], org_id: current_org.id)
      flash[:success] = "Genre added successfully.."
    else
      flash[:error] = "Error in creating genre.."
    end
    redirect_to admin_genres_path
  end

  def update
    @genre = Genre.find_by(id: params[:id], org_id: current_org.id)
    @genre.update(name: params[:name])
    flash[:success] = "Genre updated successfully.."
    redirect_to admin_genres_path
  end

  def destroy
    genre = Genre.find_by(id: params[:id])
    genre.destroy
    flash[:success] = "Genre removed successfully.."
    redirect_to admin_genres_path
  end
end
