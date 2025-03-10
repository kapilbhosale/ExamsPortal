class Admin::Api::WhatsappMessagesController < Admin::Api::ApiController

  # deeper_msg_1
  def send_message
    if params[:username] == "WhatsAppAdmin" && params[:password] == "S0m3Pass@752063"
      template = params[:template]
      values = params[:values]
      phone_number = params[:phone_number]

      response = WhatsApp.deeper_msg(template, phone_number, values)
      render json: {status: "ok", data: response}, status: :ok and return
    else
      render json: {status: "not-accepted"}, status: :unprocessable_entity and return
    end
  end

  def templates
    if params[:username] == "WhatsAppAdmin" && params[:password] == "S0m3Pass@752063"
      response = WhatsApp.get_templates
      render json: {status: "ok", data: response}, status: :ok and return
    else
      render json: {status: "not-accepted"}, status: :unprocessable_entity and return
    end
  end
end
