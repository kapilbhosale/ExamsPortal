class Admin::VideoLecturesController < Admin::BaseController
  ITEMS_PER_PAGE = 20
  require 'ostruct'
  def index
    @search = VideoLecture.includes(:subject, :genre, :batches).where(org: current_org).where(batches: {id: current_admin.batches&.ids}).all.order(id: :desc)

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

    if request.format.html?
      @video_lectures = @video_lectures.page(params[:page]).per(params[:limit] || ITEMS_PER_PAGE)
    end

    @subjects = Subject.where(org: current_org).all
    @teachers = VideoLecture.where(org: current_org).pluck(:by).uniq.map do |teacher|
      OpenStruct.new({id: teacher, name: teacher})
    end
    @folders = Genre.where(org: current_org).map do |genre|
      OpenStruct.new({ id: genre.id, name: genre.name.length > 45 ? genre.name.first(45) + '...' : genre.name })
    end
  end

  def new
    @genre = Genre.find_by(org_id: current_org.id, id: params[:genre_id])
    @video_lecture = VideoLecture.new
    @batches = Batch.where(org: current_org, id: current_admin.batches&.ids).all_batches
    @batches_with_group = Batch.where(org: current_org, id: current_admin.batches&.ids).all_batches.group_by(&:batch_group_id)
    @batch_groups = BatchGroup.where(org: current_org).index_by(&:id)
    @genres = Genre.where(org_id: current_org.id)
    @subjects = Subject.where(org_id: current_org.id)
    @is_vimeo_configured = current_org.vimeo_access_token.present?
  end

  def edit
    @video_lecture = VideoLecture.find_by(org: current_org, id: params[:id])
    @batches_with_group = Batch.where(org: current_org, id: current_admin.batches&.ids).all_batches.group_by(&:batch_group_id)
    @batch_groups = BatchGroup.where(org: current_org).index_by(&:id)
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

      if vl.publish_at <= Time.current
        vl.send_push_notifications
      end

      flash[:success] = "Video Lecture addes successfully.."
    else
      flash[:error] = vl.errors.full_messages.join(', ')
    end

    redirect_to admin_genres_path and return if params[:is_redirect_needed] == 'true'

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

  def student_video_views
    @vieo_lecture = VideoLecture.find_by(org: current_org, id: params[:video_lecture_id])

    @tracker_by_id = Tracker.where(resource_id: @vieo_lecture.id, resource_type: 'VideoLecture').index_by(&:student_id)
    @search = Student
      .where(org: current_org)
      .includes(:student_batches, :batches).joins(:batches)

    if params[:q].present? && params[:q][:batch_id].present?
      @search = @search.where(batches: {id: params[:q][:batch_id]})
    end

    @search = @search.search(search_params)

    @students = @search.result.order(created_at: :desc)

    if request.format.html?
      @students = @students.page(params[:page]).per(params[:limit] || ITEMS_PER_PAGE)
    end

    @batches = Batch.where(org: current_org).all_batches
  end

  def modity_student_views
    video_lecture = VideoLecture.find_by(org: current_org, id: params[:video_lecture_id])
    student = Student.find_by(id: params[:student_id])
    tracker = Tracker.find_by(resource_id: video_lecture.id, resource_type: 'VideoLecture', student_id: student.id)
    if tracker.present?
      view_count = tracker.data['allocated_views'].present? ? tracker.data['allocated_views'].to_i : video_lecture.view_limit.to_i
      tracker.data['allocated_views'] = view_count + params[:views].to_i
      tracker.save
      flash[:success] = "limits increased successfully"
    else
      flash[:error] = "Can not Increase view limit"
    end
    redirect_to admin_video_lecture_student_video_views_path(video_lecture)
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
      publish_at: params[:publish_at],
      view_limit: params[:view_limit],
      video_type: (params[:url]&.include?('you') ? VideoLecture.video_types['youtube'] : VideoLecture.video_types['vimeo'])
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
      publish_at: params[:publish_at],
      view_limit: params[:view_limit]
    }
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
end
