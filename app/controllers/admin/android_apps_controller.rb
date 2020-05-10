class Admin::AndroidAppsController < Admin::BaseController
  def index
    @tabs = %w[pdfs notifications top_banners gallery app_settings]

    @study_pdfs = StudyPdf.where(org: current_org).includes(:batches).all.order(id: :desc)
    @notifications = Notification.where(org: current_org).includes(:batches).all.order(id: :desc)
  end
end
