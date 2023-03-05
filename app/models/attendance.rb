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
    if org[:data]["auto_present_sms"] == true && time_entry.to_date == Date.current
      Thread.new { puts Net::HTTP.get(URI(present_sms)) }
    end
  end


  def present_sms
    sms_user = "RCCLatur"
    sms_password = URI.encode_www_form_component("RCC@123#L")
    sender_id = "RCCLtr"
    template_id = '1007511804251225784'
    entity_id = '1001545918985192145'

    msg = "From RCC\r\nDear Parent Your ward #{student.name} is Present for today #{Date.today.strftime('%d-%B-%Y')} Class,\r\nTeam RCC"
    msg = URI.encode_www_form_component(msg)

    msg_url = "#{BASE_URL}?UserID=#{sms_user}&Password=#{sms_password}&SenderID=#{sender_id}&Phno=#{student.parent_mobile}&Msg=#{msg}&EntityID=#{entity_id}&TemplateID=#{template_id}"
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
