# == Schema Information
#
# Table name: orgs
#
#  id                 :bigint(8)        not null, primary key
#  about_us_link      :string
#  data               :jsonb
#  fcm_server_key     :string
#  name               :string
#  subdomain          :string
#  vimeo_access_token :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_orgs_on_subdomain  (subdomain)
#

class Org < ApplicationRecord
  has_many :students
  has_many :att_machines

  def bhargav?
    subdomain == 'bhargav'
  end

  def sstl?
    subdomain == 'sstl'
  end

  def rcc?
    subdomain == 'exams' || subdomain == 'rcc'
  end

  def send_push_notifications
    fcm = FCM.new(fcm_server_key)
    students.where.not(fcm_token: nil).each do |student|
      fcm.send([student.fcm_token], push_options(student.name.split(' ').first))
    end
  end

  def push_options(student_name)
    {
      priority: 'high',
      data: {
        message: "#{name} - Dear #{student_name}, its time to study."
      },
      notification: {
        body: "Dear #{student_name}, lets study hard today. Lets count every minute of the day and Score More. :)",
        title: "#{name} - Study Motivation",
        image: data['push_image']
      }
    }
  end
end
