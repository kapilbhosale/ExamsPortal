class Admin::Api::DemoLoginsController < Admin::Api::ApiController
  def create
    puts "data received -----------------> #{params[:data]}"
    render json: {status: "ok"}, status: :ok
  end
end
