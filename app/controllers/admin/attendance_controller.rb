class Admin::AttendanceController < Admin::BaseController
  ITEMS_PER_PAGE = 20

  def index
    @search = Attendance.search(search_params)
    @batches = Batch.where(org: current_org).all_batches
    filtered_batch_ids = params.dig(:q, 'batch_id').present? ? params[:q]['batch_id'] : @batches.ids
    @students = Student.includes(:student_batches, :batches,).where(batches: { id: filtered_batch_ids })

    @students = @students.page(params[:page]).per(params[:limit] || ITEMS_PER_PAGE)

    @to_date = params[:to_date].present? ? Date.parse(params[:to_date]) : Date.today
    @from_date = params[:from_date].present? ? Date.parse(params[:from_date]) : Date.today - 30.days
    @today = Date.today
    @attendance = {}
    Attendance
      .where(org: current_org)
      .where(student_id: @students.ids)
      .where('time_entry >= ?', @from_date)
      .where('time_entry <= ?', @to_date)
      .each do |att|
      @attendance["#{att.student_id}-#{att.time_entry.strftime('%d%m%y')}"] = true
    end
  end

  def overview_report
    @search = Attendance.search(search_params)
    @batches = Batch.where(org: current_org).all_batches
    filtered_batch_ids = params.dig(:q, 'batch_id').present? ? params[:q]['batch_id'] : @batches.ids
    @students = Student.includes(:student_batches, :batches,).where(batches: { id: filtered_batch_ids })

    @students = @students.page(params[:page]).per(params[:limit] || ITEMS_PER_PAGE)

    @to_date = params[:to_date].present? ? Date.parse(params[:to_date]) : Date.today
    @from_date = params[:from_date].present? ? Date.parse(params[:from_date]) : Date.today - 30.days
    @today = Date.today
    @attendance = {}
    Attendance
      .where(org: current_org)
      .where(student_id: @students.ids)
      .where('time_entry >= ?', @from_date)
      .where('time_entry <= ?', @to_date)
      .each do |att|
      @attendance["#{att.student_id}-#{att.time_entry.strftime('%d%m%y')}"] = true
    end
  end

  private

  def search_params
    return {} if params[:q].blank?

    search_term = params[:q][:name_and_roll_number]&.strip

    # to check if input is number or string
    if search_term.to_i.to_s == search_term
      return { roll_number_eq: search_term } if search_term.length <= 7
      return { parent_mobile_cont: search_term }
    end

    { name_cont: search_term }
  end
end
