class AbsentMessageSenderWorker
  include Sidekiq::Worker
  def perform
    org = Org.find_by(subdomain: 'exams')

    Batch.where(org_id: org.id).all.each do |batch|
      next if batch.start_time.blank?
      next unless valid_to_send_sms?(batch)

      present_student_ids = Attendance.today.where(org_id: org.id, student_id: batch.students.ids).pluck(:student_id).uniq
      absent_students = batch.students.where.not(id: present_student_ids)

      next if absent_students.count >= present_student_ids.count

      absent_students.find_each do |student|
        send_absent_sms(student)
      end

      AttSmsLog.create({
        absent_count: absent_students.count,
        present_count: present_student_ids.count,
        batch_id: batch.id
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

  SMS_USER_NAME = "maheshrccnanded@gmail.com"
  SMS_PASSWORD = "myadmin"
  BASE_URL = "https://www.businesssms.co.in/SMS.aspx"

  def send_absent_sms(student)
  template_id = '1007771438372665235'
  msg = "From RCC\r\nDear Parent Your ward #{student.name} is absent today, #{Time.current.strftime('%d %b %y')}. Kindly confirm. \r\nTeam RCC"
  msg_url = "#{BASE_URL}?ID=#{SMS_USER_NAME}&Pwd=#{SMS_PASSWORD}&PhNo=+91#{student.parent_mobile}&TemplateID=#{template_id}&Text=#{msg}"
  encoded_uri = URI(msg_url)
  puts Net::HTTP.get(encoded_uri)
  end
end

Sidekiq::Cron::Job.create(name: 'AbsentMessageSenderWorker - every Hour Minutes', cron: '0 * * * *', class: 'AbsentMessageSenderWorker')
