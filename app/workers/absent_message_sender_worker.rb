class AbsentMessageSenderWorker
  include Sidekiq::Worker
  def perform
    Batch.all.each do |batch|
      next if batch.org.data.dig('sms_settings', 'absent_sms').blank?
      next if batch.start_time.blank?
      next unless valid_to_send_sms?(batch)

      present_student_ids = Attendance.today.where(student_id: batch.students.ids).pluck(:student_id).uniq
      absent_students = batch.students.where.not(id: present_student_ids)

      if absent_students.count >= present_student_ids.count
        AttSmsLog.create({
          absent_count: absent_students.count,
          present_count: present_student_ids.count,
          batch_id: batch.id,
          mode: 'not_sent'
        })
        next
      end

      if org[:data]["auto_absent_sms"] == true
        absent_students.find_each do |student|
          send_absent_sms(batch.org, student)
        end
      end

      AttSmsLog.create({
        absent_count: absent_students.count,
        present_count: present_student_ids.count,
        batch_id: batch.id,
        mode: 'auto'
      })
    end
  end

  def valid_to_send_sms?(batch)
    return false if already_sent_batch_ids.include?(batch.id)\
    return false if BatchHoliday.where(batch_id: batch.id, holiday_date: Date.today).present?

    Time.current.strftime('%H:%M') > (batch.end_time + 10.minutes).strftime('%H:%M')
  end

  def already_sent_batch_ids
    AttSmsLog.today.pluck(:batch_id)
  end

  BASE_URL = "http://servermsg.com/api/SmsApi/SendSingleApi"

  def send_absent_sms(org, student)
    return if org.data.dig('sms_settings', 'absent_sms').blank?

    sms_user = org.data.dig('sms_settings', 'absent_sms', 'sms_user')
    sms_password = URI.encode_www_form_component(org.data.dig('sms_settings', 'absent_sms', 'sms_password'))
    sender_id = org.data.dig('sms_settings', 'absent_sms', 'sender_id')
    template_id = org.data.dig('sms_settings', 'absent_sms', 'template_id')
    entity_id = org.data.dig('sms_settings', 'absent_sms', 'entity_id')

    msg = org.data.dig('sms_settings', 'absent_sms', 'msg').gsub('<STUDENT_NAME>', student.name).gsub('<TODAY>', Date.today.strftime('%d-%B-%Y'))
    msg = URI.encode_www_form_component(msg)
    encoded_msg = "#{BASE_URL}?UserID=#{sms_user}&Password=#{sms_password}&SenderID=#{sender_id}&Phno=#{student.parent_mobile}&Msg=#{msg}&EntityID=#{entity_id}&TemplateID=#{template_id}"

    puts Net::HTTP.get(URI(encoded_msg))
  end
end

Sidekiq::Cron::Job.create(name: 'AbsentMessageSenderWorker - every Hour Minutes', cron: '0 * * * *', class: 'AbsentMessageSenderWorker')
