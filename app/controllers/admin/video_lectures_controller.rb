class Admin::VideoLecturesController < Admin::BaseController
  require 'ostruct'
  def index
    @search = VideoLecture.includes(:subject, :genre).where(org: current_org).all.order(id: :desc)

    if params[:q].present?
      if params[:q][:subject_id].present?
        @search = @search.where(subject_id: params[:q][:subject_id])
      end

      if params[:q][:teacher_name].present?
        @search = @search.where(by: params[:q][:teacher_name])
      end

      if params[:q][:genre_id].present?
        @search = @search.where(genre_id: params[:q][:genre_id])
      end
    end

    @search = @search.search(search_params)
    @video_lectures = @search.result.order(created_at: :desc)
    @subjects = Subject.where(org: current_org).all
    @teachers = VideoLecture.where(org: current_org).pluck(:by).uniq.map do |teacher|
      OpenStruct.new({id: teacher, name: teacher})
    end
    @folders = Genre.where(org: current_org).all
  end

  def new
    @video_lecture = VideoLecture.new
    @batches = Batch.where(org: current_org).all_batches
    @genres = Genre.where(org_id: current_org.id)
    @subjects = Subject.where(org_id: current_org.id)
    @is_vimeo_configured = current_org.vimeo_access_token.present?
  end

  def edit
    @video_lecture = VideoLecture.find_by(org: current_org, id: params[:id])
    @batches = Batch.where(org: current_org).all_batches
    @genres = Genre.where(org_id: current_org.id)
    @subjects = Subject.where(org_id: current_org.id)
    @is_vimeo_configured = current_org.vimeo_access_token.present?
  end

  def chats
    @video_lecture = VideoLecture.find_by(id: params[:video_lecture_id])
    @admin = current_admin
    @messages = Message.where(messageable: @video_lecture)
  end

  def create
    if params[:url].present? && params[:video_id].present?
      flash[:error] = "Please Enter Either youtube url or Vimeo Id"
      render 'new' and return
    end
    video_type = params[:video_id].present? ? 0 : 1

    vl = VideoLecture.create(video_lecture_params.merge(video_type: video_type))
    if vl.persisted?
      if vl.video_id.present?
        AdminModule::VimeoThumbnailFetcher.new(vl.id, current_org.id).call
      end

      batches = Batch.where(id: params[:batch_ids])
      vl.batches << batches
      vl.send_push_notifications

      flash[:success] = "Video Lecture addes successfully.."
    else
      flash[:error] = vl.errors.full_messages.join(', ')
    end
    redirect_to admin_video_lectures_path
  end

  def update
    @video_lecture = VideoLecture.find_by(org: current_org, id: params[:id])
    @video_lecture.update(update_lectrue_params)
    @video_lecture.batches.destroy_all
    batches = Batch.where(id: params[:batch_ids])
    @video_lecture.batches << batches
    flash[:success] = "Video Lecture updated successfully.."
    redirect_to admin_video_lectures_path
  end

  def destroy
    vl = VideoLecture.find_by(org: current_org, id: params[:id])
    vl.destroy
    flash[:success] = "Video Lecture removed successfully.."
    redirect_to admin_video_lectures_path
  end

  private

  def update_lectrue_params
    {
      title: params[:title],
      video_id: params[:video_id],
      url: params[:url].present? ? params[:url] : "https://player.vimeo.com/video/#{params[:video_id]}",
      by: params[:by],
      tag: params[:tag],
      enabled: params[:enabled] == 'false' ? false : true,
      uploaded_thumbnail: params[:thumbnail],
      org_id: current_org.id,
      laptop_vimeo_id: params[:laptop_vimeo_id],
      genre_id: params[:genre_id],
      subject_id: params[:subject_id],
      publish_at: params[:publish_at]
    }
  end

  def video_lecture_params
    {
      title: params[:title],
      video_id: params[:video_id],
      url: params[:url].present? ? params[:url] : "https://player.vimeo.com/video/#{params[:video_id]}",
      by: params[:by],
      tag: params[:tag],
      subject_name: VideoLecture.subject_names['default'], #till we remove subject_name completely.
      subject_id: params[:subject_id],
      uploaded_thumbnail: params[:thumbnail],
      org_id: current_org.id,
      laptop_vimeo_id: params[:laptop_vimeo_id],
      genre_id: params[:genre_id],
      publish_at: params[:publish_at]
    }
  end

  def search_params
    return {} if params[:q].blank?

    {}
  end
end
