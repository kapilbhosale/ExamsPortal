class Api::V2::SubjectsController < Api::V2::ApiController
  ITEMS_PER_PAGE = 20
  def index
    if params[:type] == 'video'
      genre_ids = VideoLecture.includes(:batches, :subject).where(batches: {id: current_student.batches}).where(enabled: true).pluck(:genre_id).uniq
      subjects = Subject.where(org_id: current_org.id).includes(:genres).where(genres: {id: genre_ids, video_lectures_count: 1..Float::INFINITY }).all
      topic_counts_by_subject_id = Genre.where(org_id: current_org.id).where(id: genre_ids).where('video_lectures_count > 0').group(:subject_id).count
    else
      genre_ids = StudyPdf.includes(:batches, :subject).where(batches: {id: current_student.batches}).pluck(:genre_id).uniq
      subjects = Subject.where(org_id: current_org.id).includes(:genres).where(genres: { id: genre_ids, study_pdfs_count: 1..Float::INFINITY }).all
      topic_counts_by_subject_id = Genre.where(org_id: current_org.id).where(id: genre_ids).where('study_pdfs_count > 0').group(:subject_id).count
    end

    data = []
    subjects.each do |subject|
      data << {
        id: subject.id,
        name: subject.name,
        topics_count: topic_counts_by_subject_id[subject.id] || 0,
        updated_on: subject.genres&.last&.created_at&.strftime('%d-%b-%Y %I:%M%p') || '-'
      }
    end

    render json: data
  end

  def subject_folders
    subject = Subject.find_by(id: params[:id])
    page = (params[:page] || 1).to_i

    folders = Genre
      .where(org_id: current_org.id)
      .where(subject_id: subject&.id)
      .where(hidden: false)

    if params[:type] == 'pdfs'
      genre_ids = StudyPdf.includes(:batches, :subject).where(batches: {id: current_student.batches}).pluck(:genre_id).uniq
      folders = folders.where(id: genre_ids).where('study_pdfs_count > 0')
    else
      genre_ids = VideoLecture.includes(:batches, :subject).where(batches: {id: current_student.batches}).where(enabled: true).pluck(:genre_id).uniq
      folders = folders.where(id: genre_ids).where('video_lectures_count > 0')
    end

    total = folders.count
    folders = folders.order(id: :desc).page(page).per(params[:limit] || ITEMS_PER_PAGE)

    if folders.blank?
      render json: {
        page: page,
        page_size: ITEMS_PER_PAGE,
        total_page: 0,
        count: 0,
        data: []
      } and return
    end

    topics = []

    if params[:type] == 'pdfs'
      fodler_pdfs = StudyPdf.includes(:batches).where(batches: { id: current_student.batches.ids}).where(genre_id: folders.ids )
      pdfs_all_count_by_ids = fodler_pdfs.group(:genre_id).count
      pdfs_new_count_by_ids = fodler_pdfs.where('study_pdfs.created_at >=?', Time.current.beginning_of_day).group(:genre_id).count
    else
      fodler_videos = VideoLecture.includes(:batches).where(batches: {id: current_student.batches.ids}).where(genre_id: folders.ids)
      videos_all_count_by_ids = fodler_videos.group(:genre_id).count
      videos_new_count_by_ids = fodler_videos.where('video_lectures.created_at >=?', Time.current.beginning_of_day).group(:genre_id).count
    end

    folders.each do |folder|
      if params[:type] == 'pdfs'
        pdf = {
          count: pdfs_all_count_by_ids[folder.id],
          new: pdfs_new_count_by_ids[folder.id]
        }
      else
        video = {
          count: videos_all_count_by_ids[folder.id],
          new: videos_new_count_by_ids[folder.id]
        }
      end

      topics << {
        id: folder.id,
        name: folder.name,
        videos: video,
        pdf: pdf
      }
    end

    render json: {
      page: page,
      page_size: ITEMS_PER_PAGE,
      total_page: (total / ITEMS_PER_PAGE.to_f).ceil,
      count: total,
      data: topics
    }
  end

  def folder_videos
    subject = Subject.find_by(id: params[:subject_id])
    folder = Genre.find_by(id: params[:folder_id])
    page = (params[:page] || 1).to_i

    if current_student.block_videos?
      render json: {
        page: page,
        page_size: ITEMS_PER_PAGE,
        total_page: 0,
        count: 0,
        data: []
      } and return
    end

    videos = VideoLecture
      .includes(:batches)
      .where(org_id: current_org.id)
      .where(batches: {id: current_student.batches.ids})
      .where(genre_id: folder&.id)
      .where(enabled: true)
      .where('publish_at <= ?', Time.current)
      .where('hide_at IS NULL or hide_at >= ?', Time.current)

    if videos.blank?
      render json: {
        page: page,
        page_size: ITEMS_PER_PAGE,
        total_page: 0,
        count: 0,
        data: []
      } and return
    end

    total = videos.count
    videos = videos.order(id: :desc).page(page).per(params[:limit] || ITEMS_PER_PAGE)

    render json: {
      page: page,
      page_size: ITEMS_PER_PAGE,
      total_page: (total / ITEMS_PER_PAGE.to_f).ceil,
      count: total,
      data: videos_json(videos)
    }

  end

  # {{HOST}}/api/v2/subjects/139/folders/3703/pdfs
  def folder_pdfs
    subject = Subject.find_by(id: params[:subject_id])
    folder = Genre.find_by(id: params[:folder_id])
    page = (params[:page] || 1).to_i

    pdfs = StudyPdf
      .includes(:batches)
      .where(org_id: current_org.id)
      .where(batches: { id: current_student.batches.ids})
      .where(genre_id: folder&.id)

    if pdfs.blank?
      render json: {
        page: page,
        page_size: ITEMS_PER_PAGE,
        total_page: 0,
        count: 0,
        data: []
      } and return
    end

    total = pdfs.count
    pdfs = pdfs.order(id: :desc).page(page).per(params[:limit] || ITEMS_PER_PAGE)

    render json: {
      page: page,
      page_size: ITEMS_PER_PAGE,
      total_page: (total / ITEMS_PER_PAGE.to_f).ceil,
      count: total,
      data: pdfs_json(pdfs)
    }
  end

  def videos_json(lectures)
    lectures.map do |lect|
      lect_data = lect.attributes.slice("id" ,"title", "url", "video_id", "description", "by", "tag", "subject_id", "video_type", "play_url_from_server", "tp_streams_id")
      lect_data['thumbnail_url'] = lect.vimeo? ? lect.thumbnail : lect.uploaded_thumbnail.url
      lect_data['added_ago'] = helpers.time_ago_in_words(lect.publish_at || lect.created_at)
      if lect.vimeo?
        lect_data['play_url'] = "#{helpers.full_domain_path}/students/lectures/#{lect.video_id}"
      else
        lect_data['play_url'] = lect.url
      end

      lect_data['player'] = {
        use_first: current_org&.data.dig('player', 'use_first'), #'custom|tp_streams'
        on_error: (request.headers['buildNumber'].to_i >= 87 ? 'youtube' : nil)
      }

      lect_data['play_url_from_server'] = nil if lect.play_url_expired?

      lect_data
    end
  end

  def pdfs_json(pdfs)
    pdfs.map do |pdf|
      {
        id: pdf.id,
        name: pdf.name,
        description: pdf.description,
        tags: ["11th", "Important"],
        link: pdf.question_paper&.url,
        solution: pdf.solution_paper&.url,
        added_ago: helpers.time_ago_in_words(pdf.created_at)
      }
    end
  end
end
