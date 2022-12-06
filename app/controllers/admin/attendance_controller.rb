class Admin::AttendanceController < Admin::BaseController
  ITEMS_PER_PAGE = 20

  def index
    redirect_to overview_report_admin_attendance_index_path
  end

  def settings
    @att_machines = current_org.att_machines
  end

  def sms_logs
    @sms_logs = AttSmsLog.includes(:batch).where('created_at > ?', Time.now - 7.days)
  end

  def overview_report
    @search = Attendance.search(search_params)
    @batches = Batch.where(org: current_org).where.not(start_time: nil).all_batches.order(:id)
    filtered_batch_ids = params.dig(:q, 'batch_id').present? ? params[:q]['batch_id'] : @batches.ids
    @all_students = Student.includes(:student_batches, :batches,).where(batches: { id: filtered_batch_ids })

    if request.format.csv?
      @students = @all_students
    else
      @students = @all_students.page(params[:page]).per(params[:limit] || ITEMS_PER_PAGE)
    end

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
    @summary_data = []
    Batch.where(id: filtered_batch_ids).each do |batch|
      student_ids = Student.includes(:student_batches, :batches,).where(batches: { id: batch.id })
      pr_count = Attendance
        .where(org: current_org)
        .where(student_id: student_ids)
        .where('time_entry >= ?', Date.today)
        .where('time_entry <= ?', Date.today)
        .count
      std_count = student_ids.count
      @summary_data << {batch: batch, students_count: std_count, pr_count: pr_count, ab_count: (std_count - pr_count) }
    end

    respond_to do |format|
      format.html do
      end
      format.csv do
        att_csv = CSV.generate(headers: true) do |csv|
          header_row = ['Roll No', 'Name', 'Mobile', 'Batch']
          @from_date.upto(@to_date).each do |att_date|
            header_row << att_date.strftime("%d-%b-%y")
          end
          header_row += ['Total days', 'Present', 'Absent']
          csv << header_row
          @all_students.each do |student|
            data_row = [student.roll_number, student.name, student.parent_mobile, student.batches.pluck(:name).join(', ')]
            total_day = 0
            pr_count, ab_count = 0, 0
            @from_date.upto(@to_date).each do |day|
              total_day += 1
              if @attendance["#{student.id}-#{day.strftime('%d%m%y')}"]
                data_row << 'P'
                pr_count += 1
              else
                data_row << 'A'
                ab_count += 1
              end
            end
            data_row += [total_day, pr_count, ab_count]
            csv << data_row
          end
        end

        send_data att_csv, filename: 'AttendanceReport.csv'
      end
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
