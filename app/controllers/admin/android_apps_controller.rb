class Admin::AndroidAppsController < Admin::BaseController
  def index
    @tabs = %w[pdfs notifications live_classes gallery app_settings]
  end
end
