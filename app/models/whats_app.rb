# == Schema Information
#
# Table name: whats_apps
#
#  id           :bigint(8)        not null, primary key
#  message      :string
#  phone_number :string
#  var_1        :string
#  var_2        :string
#  var_3        :string
#  var_4        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

# WhatsApp.send_message("7588584810")

class WhatsApp < ApplicationRecord
  require 'net/http'
  require 'uri'
  require 'json'

  TOKEN = "EAASnLxSZCNSoBOzqlQcd797z5Y482vcL8ZCw1hznZAfKW4Rmfgkb1jARIRnEXplLQpJZAKk8w4V5FHWMzGY8ZAImV0DwWnU1cR0RFinDYL9YZBdVxPRkmghNcrxduk49sa5BkiOzSKFaxJI7YkLc8gzZCkwjUMOefPB4tgICvj1S8i3zrPonVEaBiPD65ZAyZB9K2ZAZAjQn6vcJcOmZBpW05SDnKnTXiQoZD"

  def self.send_message(phone_number, student_name, seat_no, center, location)
    uri = URI.parse('https://graph.facebook.com/v21.0/550289711496902/messages')
    request = Net::HTTP::Post.new(uri)
    request['Authorization'] = "Bearer #{TOKEN}"
    request['Content-Type'] = 'application/json'

    request.body = {
      messaging_product: 'whatsapp',
      recipient_type: 'individual',
      to: phone_number,
      type: 'template',
      template: {
        name: 'kcp_sat_march_2025',
        language: { code: 'en' },
        components: [
          {
            type: 'body',
            parameters: [
              { type: 'text', text: student_name },
              { type: 'text', text: seat_no },
              { type: 'text', text: center },
              { type: 'text', text: location }
            ]
          }
        ]
      }
    }.to_json

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end

    puts response.body
  end

  # WhatsApp.import_tsv_kcp('/Users/kapilbhosale/Downloads/ksat_803.tsv')
  def self.import_tsv_kcp(path)
    CSV.foreach(path, col_sep: "\t", headers: true) do |row|
      student_name = row[0]
      seat_no = row[1]
      exam_center = row[2]
      location = row[3]
      phone_number = row[4]
      puts "--------------------------------"
      puts "Sending message to #{phone_number}"
      WhatsApp.send_message(phone_number, student_name, seat_no, exam_center, location)
      puts "--------------------------------"
      # break
    end
  end

  # WhatsApp.import_tsv('/Users/kapilbhosale/Downloads/deeper_4.tsv')
  def self.import_tsv(path)
    CSV.foreach(path, col_sep: "\t", headers: true) do |row|
      student_name = row[1]
      exam_name = row[2]
      exam_date = row[3]
      exam_time = row[4]
      center_name = row[5]
      username = row[6]
      phone_number = row[8]
      values = [student_name, exam_name, exam_date, exam_time, center_name, username]
      puts "--------------------------------"
      puts "Sending message to #{phone_number}"
      WhatsApp.deeper_msg("deeper_exam_schedule", phone_number, values)
      puts "--------------------------------"
      # break
    end
  end

  def self.deeper_msg(template, phone_number, values)
    uri = URI.parse('https://graph.facebook.com/v22.0/563928240139707/messages')
    request = Net::HTTP::Post.new(uri)
    request['Authorization'] = "Bearer #{ENV.fetch('DEEPER_WA_TOKEN')}"
    request['Content-Type'] = 'application/json'

    parameters = values.map do |value|
      { type: 'text', text: value }
    end

    request.body = {
      messaging_product: 'whatsapp',
      recipient_type: 'individual',
      to: phone_number,
      type: 'template',
      template: {
        name: template,
        language: { code: 'en' },
        components: [
          {
            type: 'body',
            parameters: parameters
          }
        ]
      }
    }.to_json

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end

    return response.body
  end

  # the id used here is account id, different than phone number ID.
  def self.get_templates
    uri = URI.parse('https://graph.facebook.com/v22.0/1574803653301356/message_templates')
    request = Net::HTTP::Get.new(uri)
    request['Authorization'] = "Bearer #{ENV.fetch('DEEPER_WA_TOKEN')}"
    request['Content-Type'] = 'application/json'

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    return response.body
  end
end
