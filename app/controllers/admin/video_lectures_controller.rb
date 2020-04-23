class Admin::VideoLecturesController < Admin::BaseController
  def index
    @video_lectures = VideoLecture.all.order(id: :desc)
  end

  def new
    @video_lecture = VideoLecture.new
  end

  def edit
    @video_lecture = VideoLecture.find_by(id: params[:id])
  end

  def create
    vl = VideoLecture.create(video_lecture_params)
    batches = Batch.where(id: params[:batch_ids])
    vl.batches << batches
    flash[:success] = "Video Lecture addes successfully.."
    redirect_to admin_video_lectures_path
  end

  def update
    @video_lecture = VideoLecture.find_by(id: params[:id])
    @video_lecture.update(update_lectrue_params)
    @video_lecture.batches.destroy_all
    batches = Batch.where(id: params[:batch_ids])
    @video_lecture.batches << batches
    flash[:success] = "Video Lecture updated successfully.."
    redirect_to admin_video_lectures_path
  end

  def destroy
    vl = VideoLecture.find_by(id: params[:id])
    vl.destroy
    flash[:success] = "Video Lecture removed successfully.."
    redirect_to admin_video_lectures_path
  end

  private

  def update_lectrue_params
    {
      title: params[:title],
      video_id: params[:video_id],
      url: "https://player.vimeo.com/video/#{params[:video_id]}",
      by: params[:by],
      thumbnail: params[:thumbnail],
      tag: params[:tag],
      enabled: params[:enabled] == 'false' ? false : true
    }
  end

  def video_lecture_params
    {
      title: params[:title],
      video_id: params[:video_id],
      url: "https://player.vimeo.com/video/#{params[:video_id]}",
      by: params[:by],
      thumbnail: params[:thumbnail],
      tag: params[:tag],
      subject: VideoLecture.subjects[params[:subject]]
    }
  end
end
