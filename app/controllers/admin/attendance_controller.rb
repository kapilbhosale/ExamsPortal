class Admin::AttendanceController < Admin::BaseController
  ITEMS_PER_PAGE = 20
  BASE_URL = "http://servermsg.com/api/SmsApi/SendSingleApi"

  def index
    redirect_to overview_report_admin_attendance_index_path
  end

  def settings
    @att_machines = current_org.att_machines
  end

  def sms_logs
    @sms_logs = AttSmsLog.includes(:batch).where('created_at > ?', Time.now - 7.days)
  end

  def change_auto_sms_settings
    key = params[:q] == 'present' ? 'auto_present_sms' : 'auto_absent_sms'

    current_org['data'][key] ||= false
    current_org['data'][key] = !current_org['data'][key]
    current_org.save

    redirect_to overview_report_admin_attendance_index_path
  end

  def send_batch_sms
    batch = Batch.find_by(id: params[:batch_id])
    if batch.present?
      present_student_ids = Attendance.today.where(org_id: current_org.id, student_id: batch.students.ids).pluck(:student_id).uniq
      absent_students = batch.students.where.not(id: present_student_ids)

      if params[:type] == "present"
        Student.where(id: present_student_ids).find_each do |student|
          Thread.new { send_present_sms(student) }
        end
        REDIS_CACHE.set("att-#{Date.today.to_s}-#{batch.id}-pr", true, { ex: 24.hours })
      else
        absent_students.find_each do |student|
          Thread.new { send_absent_sms(student)  }
        end
        REDIS_CACHE.set("att-#{Date.today.to_s}-#{batch.id}-ab", true, { ex: 24.hours })
      end

      AttSmsLog.create({
        absent_count: params[:type] == "present" ? 0 : absent_students.count,
        present_count: params[:type] == "present" ? present_student_ids.count : 0,
        batch_id: batch.id,
        mode: 'manual'
      })

      flash[:success] = "Messages send request submitted successfully."
    end

    redirect_to overview_report_admin_attendance_index_path
  end

  def overview_report
    @search = Attendance.search(search_params)
    @today = Date.today
    @to_date = params[:to_date].present? ? Date.parse(params[:to_date]) : Date.today
    @from_date = params[:from_date].present? ? Date.parse(params[:from_date]) : Date.today

    @batches = Batch.where(org: current_org).where(id: current_admin.batches.ids).where.not(start_time: nil).all_batches.order(:id)
    filtered_batch_ids = params.dig(:q, 'batch_id').present? ? params[:q]['batch_id'] : @batches.ids

    @sms_settings = {
      auto_present_sms: (current_org['data']['auto_present_sms'] || false),
      auto_absent_sms: (current_org['data']['auto_absent_sms'] || false)
    }

    @summary_data = []
    @batches.each do |batch|
      student_ids = Student.includes(:student_batches, :batches,).where(batches: { id: batch.id })
      pr_count = Attendance.today.where(org: current_org).where(student_id: student_ids).count

      std_count = student_ids.count
      next if std_count == 0

      @summary_data << { batch: batch, pr_percent: (pr_count * 100 /std_count), ab_percent: 100 - (pr_count * 100/std_count) }
    end
  end

  def download_xls_report
    @batches = Batch.where(org: current_org).where.not(start_time: nil).all_batches.order(:id)
    filtered_batch_ids = params.dig(:q, 'batch_id').present? ? params[:q]['batch_id'] : @batches.ids
    batch = Batch.find_by(id: params.dig(:q, 'batch_id'))
    @students = Student.includes(:student_batches, :batches,).where(batches: { id: filtered_batch_ids })

    @to_date = params[:to_date].present? ? Date.parse(params[:to_date]) : Date.today
    @from_date = params[:from_date].present? ? Date.parse(params[:from_date]) : Date.today

    Attendance.where(org: current_org).where(student_id: @students.ids).where('time_entry >= ?', @from_date.beginning_of_day).where('time_entry <= ?', @to_date.end_of_day)
    @attendance = {}
    Attendance
      .where(org: current_org)
      .where(student_id: @students.ids)
      .where('time_entry >= ?', @from_date.beginning_of_day)
      .where('time_entry <= ?', @to_date.end_of_day)
      .each do |att|
      @attendance["#{att.student_id}-#{att.time_entry.strftime('%d%m%y')}"] = true
    end

    att_csv = CSV.generate(headers: true) do |csv|
      header_row = ['Roll No', 'Name', 'Parent Mobile', 'Student Mobile', 'Batch']
      @from_date.upto(@to_date).each do |att_date|
        header_row << att_date.strftime("%d-%b-%y")
      end
      header_row += ['Total days', 'Present', 'Absent']
      csv << header_row
      @students.each do |student|
        data_row = [student.roll_number, student.name, student.parent_mobile, student.student_mobile, student.batches.pluck(:name).join(', ')]
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

    send_data att_csv, filename: "AttendanceReport-#{Date.today}-#{batch.name}.csv"
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

  def send_present_sms(student)
    return if current_org.data.dig('sms_settings', 'present_sms').blank?

    sms_user = current_org.data.dig('sms_settings', 'present_sms', 'sms_user')
    sms_password = URI.encode_www_form_component(current_org.data.dig('sms_settings', 'present_sms', 'sms_password'))
    sender_id = current_org.data.dig('sms_settings', 'present_sms', 'sender_id')
    template_id = current_org.data.dig('sms_settings', 'present_sms', 'template_id')
    entity_id = current_org.data.dig('sms_settings', 'present_sms', 'entity_id')

    msg = current_org.data.dig('sms_settings', 'present_sms', 'msg').gsub('<STUDENT_NAME>', student.name).gsub('<TODAY>', Date.today.strftime('%d-%B-%Y'))
    msg = URI.encode_www_form_component(msg)
    encoded_msg = "#{BASE_URL}?UserID=#{sms_user}&Password=#{sms_password}&SenderID=#{sender_id}&Phno=#{student.parent_mobile}&Msg=#{msg}&EntityID=#{entity_id}&TemplateID=#{template_id}"

    puts Net::HTTP.get(URI(encoded_msg))
  end

  def send_absent_sms(student)
    return if current_org.data.dig('sms_settings', 'absent_sms').blank?

    sms_user = current_org.data.dig('sms_settings', 'absent_sms', 'sms_user')
    sms_password = URI.encode_www_form_component(current_org.data.dig('sms_settings', 'absent_sms', 'sms_password'))
    sender_id = current_org.data.dig('sms_settings', 'absent_sms', 'sender_id')
    template_id = current_org.data.dig('sms_settings', 'absent_sms', 'template_id')
    entity_id = current_org.data.dig('sms_settings', 'absent_sms', 'entity_id')

    msg = current_org.data.dig('sms_settings', 'absent_sms', 'msg').gsub('<STUDENT_NAME>', student.name).gsub('<TODAY>', Date.today.strftime('%d-%B-%Y'))
    msg = URI.encode_www_form_component(msg)
    encoded_msg = "#{BASE_URL}?UserID=#{sms_user}&Password=#{sms_password}&SenderID=#{sender_id}&Phno=#{student.parent_mobile}&Msg=#{msg}&EntityID=#{entity_id}&TemplateID=#{template_id}"

    puts Net::HTTP.get(URI(encoded_msg))
  end
end
