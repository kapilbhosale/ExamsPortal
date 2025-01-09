# == Schema Information
#
# Table name: attendances
#
#  id         :bigint(8)        not null, primary key
#  att_type   :integer          default("rfid")
#  time_entry :datetime
#  time_stamp :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  org_id     :bigint(8)
#  student_id :bigint(8)
#
# Indexes
#
#  index_attendances_on_org_id      (org_id)
#  index_attendances_on_student_id  (student_id)
#

# frozen_string_literal: true

# TODO:: record attendace only if the student have batchtime associated with it.
class Attendance < ApplicationRecord
  belongs_to :org
  belongs_to :student

  validates :student_id, uniqueness: { scope: :time_stamp }

  enum att_type: { rfid: 0, online: 1, other: 2 }

  after_create :send_sms

  scope :today, -> { where('DATE(time_entry) = ?', Date.today)}

  BASE_URL = "http://servermsg.com/api/SmsApi/SendSingleApi"

  def send_sms
    return if REDIS_CACHE.get("oid_#{org_id}_sid_#{student_id}_sms") == 'true'

    REDIS_CACHE.set("oid_#{org_id}_sid_#{student_id}_sms", 'true', { ex: 12.hours })
    if org[:data]["auto_present_sms"] == true && time_entry.to_date == Date.current
      Thread.new { send_present_sms }
    end
  end

  # org.data['sms_settings'] ||= {}
  #
  # org.data['sms_settings']['present_sms'] = {
  #   sms_user: 'RCCLatur',
  #   sms_password: 'RCC@123#L',
  #   sender_id: 'RCCLtr',
  #   template_id: '1007511804251225784',
  #   entity_id: '1001545918985192145',
  #   msg: 'From RCC\r\nDear Parent Your ward <STUDENT_NAME> is Present for today <TODAY> Class,\r\nTeam RCC'
  # }

  # org.data['sms_settings']['absent_sms'] = {
  #   sms_user: 'RCCLatur',
  #   sms_password: 'RCC@123#L',
  #   sender_id: 'RCCLtr',
  #   template_id: '1007771438372665235',
  #   entity_id: '1001545918985192145',
  #   msg: "From RCC\r\nDear Parent Your ward <STUDENT_NAME> is absent today, <TODAY>. Kindly confirm. \r\nTeam RCC"
  # }

  # org.data['sms_settings']['present_sms'] = {
  #   sms_user: 'Ganesh1',
  #   sms_password: 'Ganesh@123#',
  #   sender_id: 'SGECLT',
  #   template_id: '1007404577984635679',
  #   entity_id: '1001992529630396659',
  #   msg: "Respected Parents, \r\nYour ward <STUDENT_NAME> is PRESENT for today's <TODAY> class.\r\nFrom, Shri Ganesh English Classes"
  # }

  # org.data['sms_settings']['absent_sms'] = {
  #   sms_user: 'Ganesh1',
  #   sms_password: 'Ganesh@123#',
  #   sender_id: 'SGECLT',
  #   template_id: '1007652380983349299',
  #   entity_id: '1001992529630396659',
  #   msg: "Respected Parents, \r\nYour ward <STUDENT_NAME> is ABSENT for today's <TODAY> class.\r\nFrom, Shri Ganesh English Classes"
  # }

  # org = Org.find_by(subdomain: 'lbs')
  # org.data['sms_settings'] = {}
  # org.data['sms_settings']['present_sms'] = {
  #   sms_user: 'BBHBeed',
  #   sms_password: 'BBH@123',
  #   sender_id: 'BBHBid',
  #   template_id: '1007680264902240438',
  #   entity_id: '1001298244990130034',
  #   msg: "From : LBS School Basmath \r\nDear Parent, \r\nYour ward <STUDENT_NAME> is PRESENT on Date; <TODAY>\r\n-LBSBMT"
  # }

  # org.data['sms_settings']['absent_sms'] = {
  #   sms_user: 'LBS',
  #   sms_password: 'LBS@123#',
  #   sender_id: 'LBSBMT',
  #   template_id: '1007500949929358876',
  #   entity_id: '1001298244990130034',
  #   msg: "From: LBS School, Basmath \r\nDear Parent, Your ward <STUDENT_NAME> is ABSENT <TODAY>.\r\n-LBSBMT"
  # }

  def send_present_sms
    return if org.data.dig('sms_settings', 'present_sms').blank?

    sms_user = org.data.dig('sms_settings', 'present_sms', 'sms_user')
    sms_password = URI.encode_www_form_component(org.data.dig('sms_settings', 'present_sms', 'sms_password'))
    sender_id = org.data.dig('sms_settings', 'present_sms', 'sender_id')
    template_id = org.data.dig('sms_settings', 'present_sms', 'template_id')
    entity_id = org.data.dig('sms_settings', 'present_sms', 'entity_id')

    msg = URI.encode_www_form_component(build_msg)
    encoded_msg = "#{BASE_URL}?UserID=#{sms_user}&Password=#{sms_password}&SenderID=#{sender_id}&Phno=#{student.parent_mobile}&Msg=#{msg}&EntityID=#{entity_id}&TemplateID=#{template_id}"

    puts Net::HTTP.get(URI(encoded_msg))
  end

  def build_msg
    org.data.dig('sms_settings', 'present_sms', 'msg').gsub('<STUDENT_NAME>', student.name).gsub('<TODAY>', time_entry.strftime('%d-%B-%Y %I:%M %p'))
  end
end

# # script to create attendance
# student_ids = [1,2,3,5,6,7]
# year = 2021
# month = 01
# hh = 10
# mm = [05, 10, 20, 30, 40, 50]

# # Time.local(2021, 02, 13, 12, 50)

# student_ids.each do |student_id|
#   1.upto(31).each do |i|
#     time_entry = Time.local(year, month, i, hh, mm.sample)
#     Attendance.create({
#       time_entry: time_entry,
#       time_stamp: time_entry.to_i,
#       org_id: 1,
#       student_id: student_id
#     })
#   end
# end
