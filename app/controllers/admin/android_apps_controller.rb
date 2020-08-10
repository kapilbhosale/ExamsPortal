class Admin::AndroidAppsController < Admin::BaseController
  def index
    @tabs = %w[pdfs notifications zoom_meetings gallery app_settings]

    @study_pdfs = StudyPdf.includes(:study_pdf_type, :org).where(org: current_org).includes(:batches).all.order(id: :desc)
    @notifications = Notification.includes(:org).where(org: current_org).includes(:batches).all.order(id: :desc)
    @meetings = ZoomMeeting.includes(:org).where(org: current_org).includes(:batches).all.order(id: :desc)
  end
end
