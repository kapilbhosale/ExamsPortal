class Admin::MessagesController < Admin::BaseController
  before_action :authenticate_admin!
  skip_before_action :verify_authenticity_token

  def index
  end

  def create
    message = Message.create(message_params)
    if message.errors.blank?
      roll_number = message.sender_type == 'Student' ? message.sender.roll_number : message.sender_id
      msg_class = message.sender_type == 'Student' ? 'student-msg' : 'admin-msg'
      chat_message = "<div class='#{msg_class}'><p><b>[#{roll_number}] #{message.sender_name}:</b> #{message.message}</p><span class='time-left'>#{message.created_at.strftime("%I:%M %p")}</span></div>"
      VideoChatChannel.broadcast_to message.messageable, message: chat_message
      render json: {}, status: :ok and return
    else
      render json: {error: message.errors.full_messages.join(',')}, status: 422 and return
    end
  end

  private

  def message_params
    params.permit(:message, :sender_name, :sender_type, :sender_id, :messageable_type, :messageable_id)
  end
end