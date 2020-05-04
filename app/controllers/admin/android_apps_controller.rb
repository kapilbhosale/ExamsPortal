class Admin::AndroidAppsController < Admin::BaseController
  def index
    @tabs = %w[pdfs top_banners notifications gallery app_settings]

    @study_pdfs = StudyPdf.where(org: current_org).includes(:batches).all
  end

end
