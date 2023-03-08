# frozen_string_literal: true
class Api::V2::VideosController < Api::V2::ApiController
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
    video = VideoLecture.find_by(id: params[:video_id])
    if video
      render json: { comments: video.messages.order(id: :desc) }
    else
      render json: { message: 'Cannot get comments' }, status: 402
    end
  end

  def add_comment
    video = VideoLecture.find_by(id: params[:video_id])
    student_id = current_student&.id || params[:student_id]
    if video && student_id && params[:comment].present?
      student = current_student || Student.find_by(id: student_id)
      video.messages.create(
        message: params[:comment],
        sender_type: 'Student',
        sender_id: student_id,
        sender_name: student.name.split(' ').first
      )
      render json: { message: 'Comment added, Thank you.' }
    else
      render json: { message: 'Cannot add comment' }, status: 402
    end
  end

  def remove_comment
    student_id = current_student&.id || params[:student_id]
    if student_id.present?
      Message.find_by(
        sender_type: 'Student',
        sender_id: student_id,
        id: params[:comment_id]
      )&.destroy
    end
    render json: 'ok'
  end


  private
end
