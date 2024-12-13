class AuthenticatedUrl
  # Encode data into a URL-safe format
  def self.encoded_url(roll_number:, mobile_number:)
    data = "#{roll_number}|#{mobile_number}"
    token = Base64.urlsafe_encode64("#{data}")
    "https://exams.smartclassapp.in/students/ht?token=#{token}"
  end

  # Decode data and validate checksum
  def self.decode_data(token)
    decoded = Base64.urlsafe_decode64(token)

    roll_number, mobile_number = decoded.split('|')
    { roll_number: roll_number, mobile_number: mobile_number }
  end
end
