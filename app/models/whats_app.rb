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

  TOKEN = "EAASzXyml6M4BO2595Qc7f4SusnuvqNRjFsLI435gMAvVc2SI3yVtTJ1W7ZAsef8EsNQmzgihQ8iZA6obZAXqc6HpI0vjXOXCgEYQ1iw74zXCza7ySRy4qHHufxuWpDMRxdWcNj8epOyZBgSfcCZAyObSUt8oGbEJu9VTk4JWZA4VScx61hmJxOTTOJupPE8ONASN0yzpBW5ZCVlWzZAwMYvKAynTOkUZD"

  def self.send_message(phone_number, student_name, exam_no, center, location)
    uri = URI.parse('https://graph.facebook.com/v21.0/487098331157481/messages')
    request = Net::HTTP::Post.new(uri)
    request['Authorization'] = "Bearer #{TOKEN}"
    request['Content-Type'] = 'application/json'

    request.body = {
      messaging_product: 'whatsapp',
      recipient_type: 'individual',
      to: phone_number,
      type: 'template',
      template: {
        name: 'kcp_testfoundation',
        language: { code: 'en' },
        components: [
          {
            type: 'body',
            parameters: [
              { type: 'text', text: " #{student_name}" },
              { type: 'text', text: exam_no },
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

  # WhatsApp.import_tsv('/Users/kapilbhosale/Downloads/kcp_day2.tsv')
  def self.import_tsv(path)
    CSV.foreach(path, col_sep: "\t", headers: true) do |row|
      phone_number = row[4]
      student_name = row[0]
      exam_no = row[1]
      center = row[2]
      location = row[3]
      puts "--------------------------------"
      puts "Sending message to #{phone_number}"
      WhatsApp.send_message(phone_number, student_name, exam_no, center, location)
      puts "--------------------------------"
    end
  end
end
