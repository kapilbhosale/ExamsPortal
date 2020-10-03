class Admin::AndroidAppsController < Admin::BaseController
  def index
    @tabs = %w[pdfs notifications live_classes gallery app_settings]
    @study_pdfs = StudyPdf.includes(:study_pdf_type, :org).where(org: current_org).includes(:batches).where(batches: {id: current_admin.batches&.ids}).all.order(id: :desc)
    @notifications = Notification.includes(:org).where(org: current_org).includes(:batches).where(batches: {id: current_admin.batches&.ids}).all.order(id: :desc)
    @meetings = ZoomMeeting.includes(:org).where(org: current_org).includes(:batches).where(batches: {id: current_admin.batches&.ids}).all.order(id: :desc)
  end
end
