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
end

SMS_USER_NAME = "maheshrccnanded@gmail.com"
SMS_PASSWORD = "myadmin"
BASE_URL = "https://www.businesssms.co.in/SMS.aspx";

def send_sms
  if time_entry.to_date == Date.current
    template_id = '1007511804251225784'
    # msg = "Dear Students, \nWelcome in the world of RCC. \nYour admission is confirmed. \nName: #{name} \nCourse:#{batches.pluck(:name).join(",")} \nyour Login details are \nRoll Number: #{roll_number} \nParent Mobile: #{parent_mobile}\n Download App from given link \nhttps://play.google.com/store/apps/details?id=com.at_and_a.rcc_new"
    msg = "From RCC\r\nDear Parent Your ward #{student.name} is Present for today #{time_entry.strftime('%d %b %y')} Class,\r\nTeam RCC"
    msg_url = "#{BASE_URL}?ID=#{SMS_USER_NAME}&Pwd=#{SMS_PASSWORD}&PhNo=+91#{student.parent_mobile}&TemplateID=#{template_id}&Text=#{msg}"
    encoded_uri = URI(msg_url)
    puts Net::HTTP.get(encoded_uri)
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
