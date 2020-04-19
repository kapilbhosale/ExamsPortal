module Students
  class SyncStudentWithAppService
    attr_reader :student, :batch_name

    def initialize(student)
      @student = student
      @batch_name = student.batches&.last&.name
    end

    def sync
      require 'net/http'
      require 'uri'
      require 'json'

      uri = URI.parse(get_uri)
      header = {'Content-Type' => 'application/json'}

      post_data = {
        token: "SmartClassApp@t0k3N@!@#",
        student: {
          name: student.name,
          roll_number: student.roll_number,
          parent_mobile_number: student.parent_mobile
        },
        batch_name: batch_name
      }

      # Create the HTTP objects
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.request_uri, header)
      request.body = post_data.to_json

      # Send the request
      response = http.request(request)
      if response.code == 200
        puts "\n\n\n\n\n\n Synced successfully .. ! #{post_data}"
      else
        puts "\n\n\n\n\n\n $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
        puts " FAILED #{post_data}"
        puts "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
      end
    end

    def get_uri
      sub_domain = "backend"
      if batch_name&.downcase&.include?('latur')
        sub_domain = "rcclatur"
      end
      "http://#{sub_domain}.smartclassapp.in/api/v1/student-sync"
      # "http://admin.lvh.me:1234/api/v1/student-sync"
    end
  end
end
