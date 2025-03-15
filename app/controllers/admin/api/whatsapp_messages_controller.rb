class Admin::Api::WhatsappMessagesController < Admin::Api::ApiController
  skip_before_action :authenticate
  before_action :set_client

  def send_message
    template = params[:template]
    values = params[:values]
    phone_number = params[:phone_number]

    response = WhatsApp.send_msg(@client, template, phone_number, values)
    render json: {status: "ok", data: response}, status: :ok and return
  end

  def templates
    response = WhatsApp.get_templates(@client)
    render json: {status: "ok", data: response}, status: :ok and return
  end

  private

  def set_client
    if params[:username] == "WhatsAppAdmin"
      @client = "DEEPER" if params[:password] == "S0m3Pass@752063"
      @client = "KCP" if params[:password] == "KCP@WaP@ss_10"

      if @client.blank?
        render json: {status: "not-accepted"}, status: :unprocessable_entity and return
      end
    else
      render json: {status: "not-accepted"}, status: :unprocessable_entity and return
    end
  end
end
