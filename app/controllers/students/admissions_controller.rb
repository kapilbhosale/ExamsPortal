require 'openssl'
require 'base64'

class Students::AdmissionsController < ApplicationController
  layout false, only: [:show]
  MERCHANT_ID = "3300260987"
  skip_before_action :verify_authenticity_token, only: [:admission_done]

  def show
    @errors = []
    # @url = eazy_pay_url
  end

  def print_receipt
    @new_admission = NewAdmission.find_by(reference_id: params[:reference_id])
    render pdf: "student information",
            template: "/students/admissions/receipt.pdf.erb",
            locals: {students: {}},
            footer: { font_size: 9, left: DateTime.now.strftime("%d-%B-%Y %I:%M%p"), right: 'Page [page] of [topage]' }
  end

  def create
    errors = []
    must_have_params = [:name, :email, :parent_mobile, :student_mobile, :batch, :course, :gender, :rcc_branch]
    must_have_params.each do |key|
      errors << "#{key.to_s.humanize} cannot be blank." if new_admission_params[key].blank?
    end
    if params[:parent_mobile].length != 10 || !is_number?(params[:parent_mobile])
      errors << "Invalid Parent mobile, must be of lenght 10 or not a number"
    end
    if params[:student_mobile].length != 10 || !is_number?(params[:student_mobile])
      errors << "Invalid Parent mobile, must be of lenght 10 or not a number"
    end

    course_name = new_admission_params.delete(:course)
    course = Course.find_by(name: course_name)

    errors << "Invalid Course, please contact admin." if course.blank?

    if errors.blank?
      new_admission = NewAdmission.new
      new_admission.name = new_admission_params[:name]
      new_admission.email = new_admission_params[:email]
      new_admission.parent_mobile = new_admission_params[:parent_mobile]
      new_admission.student_mobile = new_admission_params[:student_mobile]
      new_admission.batch = NewAdmission.batches[new_admission_params[:batch]]
      new_admission.rcc_branch = NewAdmission.rcc_branches[new_admission_params[:rcc_branch]]
      new_admission.course_id = course.id
      new_admission.gender = new_admission_params[:gender]

      if new_admission.save
        new_admission.in_progress!
        redirect_to eazy_pay_url(
          new_admission.payment_id,
          course.fees.to_s,
          "#{new_admission.parent_mobile}#{new_admission.id}")
      else
        flash[:error] = new_admission.errors.full_messages
        redirect_back(fallback_location: '/new-admission')
      end
    else
      flash[:error] = errors
      redirect_back(fallback_location: '/new-admission')
    end
  end

  def admission_done
    puts "PAYMENT**********"
    puts params
    puts "PAYMENT**********"
    @params = params
    @status = (params['Response Code'] == 'E000')
    @error_code = params['Response Code']
    @new_admission = NewAdmission.find_by(payment_id: params['ReferenceNo'])

    if @new_admission
      @new_admission.payment_callback_data = params
      @new_admission.error_code = @error_code
      @new_admission.error_info = error_info[@error_code]
      if @status
        @new_admission.success!
      else
        @new_admission && @new_admission.failure!
      end
      @new_admission.save
    end
    @erorr_info = error_info[@error_code]
  end

  private
    # data = "8001|1234|80|9000000001"

    def is_number? string
      true if Float(string) rescue false
    end

    def encrypt(data)
      key = "2703410300705007"
      cipher = OpenSSL::Cipher.new("AES-128-ECB")
      cipher.encrypt()
      cipher.key = key
      crypt = cipher.update(data) + cipher.final

      crypt_string = (Base64.encode64(crypt))
      crypt_string
    end

    def eazy_pay_url(record_id, amount, parent_mobile)
      icid = "270074"
      reference_number = record_id    # db id for the the admission table
      sub_merchant_id = parent_mobile     #student roll _number
      transaction_amount = amount
      optional_fields = ""

      mandatory_fields = "#{reference_number}|#{sub_merchant_id}|#{transaction_amount}"
      return_url = "https://exams.smartclassapp.in/admission-done"

      plain_url = "https://eazypay.icicibank.com/EazyPG?merchantid=#{icid}&mandatory fields=#{mandatory_fields}&optional fields=&returnurl=#{(return_url)}&Reference No=#{(reference_number)}&submerchantid=#{(sub_merchant_id)}&transaction amount=#{(transaction_amount)}&paymode=#{('9')}"

      "https://eazypay.icicibank.com/EazyPG?merchantid=#{icid}&mandatory%20fields=#{encrypt(mandatory_fields)}&optional%20fields=&returnurl=#{encrypt(return_url)}&Reference No=#{encrypt(reference_number)}&submerchantid=#{encrypt(sub_merchant_id)}&transaction%20amount=#{encrypt(transaction_amount)}&paymode=#{encrypt('9')}"
    end

    def new_admission_params
      params.permit(:name, :email, :parent_mobile, :student_mobile, :batch, :course, :gender, :rcc_branch)
    end


    def error_info
      {
        "E000" => "Received successful confirmation in real time for the transaction. Settlement process is initiated for the transaction",
        "E001" => "Unauthorized Payment Mode",
        "E002" => "Unauthorized Key",
        "E003" => "Unauthorized Packet",
        "E004" => "Unauthorized Merchant",
        "E005" => "Unauthorized Return URL",
        "E006" => "Transaction is already paid",
        "E007" => "Transaction Failed",
        "E008" => "Failure from Third Party due to Technical Error",
        "E009" => "Bill Already Expired",
        "E0031" => "Mandatory fields coming from merchant are empty",
        "E0032" => "Mandatory fields coming from database are empty",
        "E0033" => "Payment mode coming from merchant is empty",
        "E0034" => "PG Reference number coming from merchant is empty",
        "E0035" => "Sub merchant id coming from merchant is empty",
        "E0036" => "Transaction amount coming from merchant is empty",
        "E0037" => "Payment mode coming from merchant is other than 0 to 9",
        "E0038" => "Transaction amount coming from merchant is more than 9 digit length",
        "E0039" => "Mandatory value Email in wrong format",
        "E00310" => "Mandatory value mobile number in wrong format",
        "E00311" => "Mandatory value amount in wrong format",
        "E00312" => "Mandatory value Pan card in wrong format",
        "E00313" => "Mandatory value Date in wrong format",
        "E00314" => "Mandatory value String in wrong format",
        "E00315" => "Optional value Email in wrong format",
        "E00316" => "Optional value mobile number in wrong format",
        "E00317" => "Optional value amount in wrong format",
        "E00318" => "Optional value pan card number in wrong format",
        "E00319" => "Optional value date in wrong format",
        "E00320" => "Optional value string in wrong format",
        "E00321" => "Request packet mandatory columns is not equal to mandatory columns set in enrolment or optional columns are not equal to optional columns length set in enrolment",
        "E00322" => "Reference Number Blank",
        "E00323" => "Mandatory Columns are Blank",
        "E00324" => "Merchant Reference Number and Mandatory Columns are Blank",
        "E00325" => "Merchant Reference Number Duplicate",
        "E00326" => "Sub merchant id coming from merchant is non numeric",
        "E00327" => "Cash Challan Generated",
        "E00328" => "Cheque Challan Generated",
        "E00329" => "NEFT Challan Generated",
        "E00330" => "Transaction Amount and Mandatory Transaction Amount mismatch in Request URL",
        "E00331" => "UPI Transaction Initiated Please Accept or Reject the Transaction",
        "E00332" => "Challan Already Generated, Please re-initiate with unique reference number",
        "E00333" => "Referer is null/invalid Referer",
        "E00334" => "Mandatory Parameters Reference No and Request Reference No parameter values are not matched",
        "E00335" => "Transaction Cancelled By User",
        "E0801" => "FAIL",
        "E0802" => "User Dropped",
        "E0803" => "Canceled by user",
        "E0804" => "User Request arrived but card brand not supported",
        "E0805" => "Checkout page rendered Card function not supported",
        "E0806" => "Forwarded / Exceeds withdrawal amount limit",
        "E0807" => "PG Fwd Fail / Issuer Authentication Server failure",
        "E0808" => "Session expiry / Failed Initiate Check, Card BIN not present",
        "E0809" => "Reversed / Expired Card",
        "E0810" => "Unable to Authorize",
        "E0811" => "Invalid Response Code or Guide received from Issuer",
        "E0812" => "Do not honor",
        "E0813" => "Invalid transaction",
        "E0814" => "Not Matched with the entered amount",
        "E0815" => "Not sufficient funds",
        "E0816" => "No Match with the card number",
        "E0817" => "General Error",
        "E0818" => "Suspected fraud",
        "E0819" => "User Inactive",
        "E0820" => "ECI 1 and ECI6 Error for Debit Cards and Credit Cards",
        "E0821" => "ECI 7 for Debit Cards and Credit Cards",
        "E0822" => "System error. Could not process transaction",
        "E0823" => "Invalid 3D Secure values",
        "E0824" => "Bad Track Data",
        "E0825" => "Transaction not permitted to cardholder",
        "E0826" => "Rupay timeout from issuing bank",
        "E0827" => "OCEAN for Debit Cards and Credit Cards",
        "E0828" => "E-commerce decline",
        "E0829" => "This transaction is already in process or already processed",
        "E0830" => "Issuer or switch is inoperative",
        "E0831" => "Exceeds withdrawal frequency limit",
        "E0832" => "Restricted card",
        "E0833" => "Lost card",
        "E0834" => "Communication Error with NPCI",
        "E0835" => "The order already exists in the database",
        "E0836" => "General Error Rejected by NPCI",
        "E0837" => "Invalid credit card number",
        "E0838" => "Invalid amount",
        "E0839" => "Duplicate Data Posted",
        "E0840" => "Format error",
        "E0841" => "SYSTEM ERROR",
        "E0842" => "Invalid expiration date",
        "E0843" => "Session expired for this transaction",
        "E0844" => "FRAUD - Purchase limit exceeded",
        "E0845" => "Verification decline",
        "E0846" => "Compliance error code for issuer",
        "E0847" => "Caught ERROR of type:[ System.Xml.XmlException ] . strXML is not a valid XML string Failed in Authorize - I",
        "E0848" => "Incorrect personal identification number",
        "E0849" => "Stolen card",
        "E0850" => "Transaction timed out, please retry",
        "E0851" => "Failed in Authorize - PE",
        "E0852" => "Cardholder did not return from Rupay",
        "E0853" => "Missing Mandatory Field(s)The field card_number has exceeded the maximum length of 19",
        "E0854" => "Exception in CheckEnrollmentStatus: Data at the root level is invalid. Line 1, position 1.",
        "E0855" => "CAF status = 0 or ",
        "E0856" => "412",
        "E0857" => "Allowable number of PIN tries exceeded",
        "E0858" => "No such issuer",
        "E0859" => "Invalid Data Posted",
        "E0860" => "PREVIOUSLY AUTHORIZED",
        "E0861" => "Cardholder did not return from ACS",
        "E0862" => "Duplicate transmission",
        "E0863" => "Wrong transaction state",
        "E0864" => "Card acceptor contact acquirer"
      }
    end
end
