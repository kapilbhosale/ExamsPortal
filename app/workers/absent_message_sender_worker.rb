class AbsentMessageSenderWorker
  include Sidekiq::Worker
  def perform
    orgs = Org.where(subdomain: ['exams', 'rcc'])

    Batch.where(org_id: orgs.ids).all.each do |batch|
      next if batch.start_time.blank?
      next unless valid_to_send_sms?(batch)

      present_student_ids = Attendance.today.where(org_id: org.id, student_id: batch.students.ids).pluck(:student_id).uniq
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
          send_absent_sms(student)
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
    return false if already_sent_batch_ids.include?(batch.id)
    Time.current.strftime('%H:%M') > (batch.end_time + 10.minutes).strftime('%H:%M')
  end

  def already_sent_batch_ids
    AttSmsLog.today.pluck(:batch_id)
  end

  BASE_URL = "http://servermsg.com/api/SmsApi/SendSingleApi"

  def send_absent_sms(student)
    Thread.new { puts Net::HTTP.get(URI(absent_sms(student))) }
  end

  def absent_sms(student)
    if current_org.rcc?
      sms_user = "RCCLatur"
      sms_password = URI.encode_www_form_component("RCC@123#L")
      sender_id = "RCCLtr"
      template_id = '1007771438372665235'
      entity_id = '1001545918985192145'

      msg = "From RCC\r\nDear Parent Your ward #{student.name} is absent today, #{Date.today.strftime('%d-%B-%Y')}. Kindly confirm. \r\nTeam RCC"
      msg = URI.encode_www_form_component(msg)

      msg_url = "#{BASE_URL}?UserID=#{sms_user}&Password=#{sms_password}&SenderID=#{sender_id}&Phno=#{student.parent_mobile}&Msg=#{msg}&EntityID=#{entity_id}&TemplateID=#{template_id}"
    end
  end
end

Sidekiq::Cron::Job.create(name: 'AbsentMessageSenderWorker - every Hour Minutes', cron: '0 * * * *', class: 'AbsentMessageSenderWorker')
