# frozen_string_literal: true
class Api::V2::VideosController < Api::V2::ApiController
  before_action :authenticate
  ITEMS_PER_PAGE = 20

  def like
    video = VideoLecture.find_by(id: params[:video_id])
    student_id = current_student&.id || params[:student_id]
    if video && student_id && video.likes.where(student_id: student_id).count.zero?
      video.likes.create(student_id: student_id)
    end
    render json: 'ok'
  end

  def dislike
    video = VideoLecture.find_by(id: params[:video_id])
    student_id = current_student&.id || params[:student_id]
    if video && student_id
      video.likes.where(student_id: student_id).delete_all
    end
    render json: 'ok'
  end

  def comments
    page = (params[:page] || 1).to_i
    video = VideoLecture.find_by(org_id: current_org.id, id: params[:video_id])
    total = video.messages.count
    comments  = video.messages.order(id: :desc).page(page).per(ITEMS_PER_PAGE)

    render json: {
      page: page,
      page_size: ITEMS_PER_PAGE,
      total_page: (total / ITEMS_PER_PAGE.to_f).ceil,
      count: total,
      data: [
        comments: comments
      ]
    }
  end

  def add_comment
    video = VideoLecture.find_by(id: params[:video_id])
    student_id = current_student&.id

    if video && student_id && params[:comment].present?
      student = current_student || Student.find_by(id: student_id)
      comment = video.messages.create(
        message: params[:comment],
        sender_type: 'Student',
        sender_id: student_id,
        sender_name: student.name.split(' ').first
      )
      render json: comment
    else
      render json: { message: 'Cannot add comment' }, status: 402
    end
  end

  def remove_comment
    student_id = current_student&.id
    if student_id.present?
      Message.find_by(
        sender_type: 'Student',
        sender_id: student_id,
        id: params[:comment_id]
      )&.destroy
    end
    render json: 'ok'
  end
end
