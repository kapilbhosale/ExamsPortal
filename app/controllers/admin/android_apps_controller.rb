class Admin::AndroidAppsController < Admin::BaseController
  def index
    @tabs = %w[top_banners pdfs notifications gallery app_settings]
  end

end
