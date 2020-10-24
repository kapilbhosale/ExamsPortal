class VideoChatChannel < ApplicationCable::Channel
  def subscribed
    stream_for video_lecture
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def video_lecture
    ZoomMeeting.find_by(id: params[:id])
  end
end
