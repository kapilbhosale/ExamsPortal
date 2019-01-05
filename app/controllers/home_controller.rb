class HomeController < ApplicationController
  def auth
  end

  def current_server_time
    render json: {time: Time.current}, status: :ok
  end
end
