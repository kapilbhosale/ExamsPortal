require 'openssl'
require 'base64'

class Students::AdmissionsController < ApplicationController
  # layout false, only: [:show]
  MERCHANT_ID = "3300260987"

  def show
    @url = eazy_pay_url
  end

  def create
    # binding.pry
    redirect_to eazy_pay_url
  end

  def admission_done
    binding.pry
    puts params
    @params = params
  end

  private
    # data = "8001|1234|80|9000000001"

    def encrypt(data)
      key = "2703410300705007"
      cipher = OpenSSL::Cipher.new("AES-128-ECB")
      cipher.encrypt()
      cipher.key = key
      crypt = cipher.update(data) + cipher.final

      crypt_string = (Base64.encode64(crypt))
      crypt_string
    end

    def eazy_pay_url
      icid = "270074"
      reference_number = "10002"    # db id for the the admission table
      sub_merchant_id = "12345"     #student roll _number
      transaction_amount = '101'

      mandatory_fields = "#{reference_number}|#{sub_merchant_id}|#{transaction_amount}"
      return_url = "https://localhost:3000/students"

      plain_url = "https://eazypay.icicibank.com/EazyPG?merchantid=#{icid}&mandatory fields=#{mandatory_fields}&optional fields=&returnurl=#{(return_url)}&Reference No=#{(reference_number)}&submerchantid=#{(sub_merchant_id)}&transaction amount=#{(transaction_amount)}&paymode=#{('9')}"

      "https://eazypay.icicibank.com/EazyPG?merchantid=#{icid}&mandatory%20fields=#{encrypt(mandatory_fields)}&optional%20fields=&returnurl=#{encrypt(return_url)}&Reference No=#{encrypt(reference_number)}&submerchantid=#{encrypt(sub_merchant_id)}&transaction%20amount=#{encrypt(transaction_amount)}&paymode=#{encrypt('9')}"
    end
end
