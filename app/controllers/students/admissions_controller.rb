require 'openssl'
require 'base64'

class Students::AdmissionsController < ApplicationController
  layout false, only: [:show, :pay_installment, :create_installment]
  MERCHANT_ID = "3300260987"
  skip_before_action :verify_authenticity_token, only: [:admission_done, :create]

  def show
    redirect_to '/' unless request.subdomain == 'exams'
    @errors = []
    # @url = eazy_pay_url
  end

  def pay_installment
    redirect_to '/' unless request.subdomain == 'exams'
    @errors = []
  end

  def create_installment
    if params[:roll_number].present? && params[:parent_mobile].present?
      @student = Student.find_by(parent_mobile: params[:parent_mobile], roll_number: params[:roll_number])
      if @student.present?
        render 'show'
      else
        flash[:error] = ['please enter valid roll number and parent mobile']
        redirect_back(fallback_location: '/pay-installment')
      end
    else
      flash[:error] = ['please enter valid roll number and parent mobile']
      redirect_back(fallback_location: '/pay-installment')
    end
  end

  def pay_due_fees
    errors = []
    student = Student.find_by(id: params[:student_id])
    if student.blank?
      flash[:error] = "Invalid student id, please contact admin."
      redirect_back(fallback_location: '/')
    end

    new_admission = NewAdmission.new
    new_admission.name = student.name
    new_admission.email = student.email
    new_admission.parent_mobile = student.parent_mobile
    new_admission.student_mobile = student.student_mobile
    new_admission.batch = NewAdmission.batches[new_admission_params[:batch]]
    new_admission.rcc_branch = NewAdmission.rcc_branches[new_admission_params[:rcc_branch]]
    new_admission.student_id = student.id

    if new_admission.save
      new_admission.in_progress!
      redirect_to get_eazy_pay_due_amount_url(new_admission, student)
    else
      flash[:error] = new_admission.errors.full_messages
      redirect_back(fallback_location: '/')
    end
  end

  def print_receipt
    @new_admission = NewAdmission.find_by(reference_id: params[:reference_id])
    @fees = @new_admission.payment_callback_data['Total Amount'].to_f
    @processing_fees = @new_admission.student_id.present? ? 0 : 120
    render pdf: "Payment Receipt",
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

    @student = Student.find_by(id: new_admission_params[:student_id])

    if params[:parent_mobile]&.length != 10 || !is_number?(params[:parent_mobile])
      errors << "Invalid Parent mobile, must be of lenght 10 or not a number"
    end

    if params[:student_mobile]&.length != 10 || !is_number?(params[:student_mobile])
      errors << "Invalid Parent mobile, must be of lenght 10 or not a number"
    end

    if params[:email] && !params[:email].downcase.match?(URI::MailTo::EMAIL_REGEXP)
      errors << "Please enter valid email."
    end

    if errors.blank?
      selected_courses = new_admission_params.delete(:course)
      course = Course.get_course(selected_courses)

      new_admission = NewAdmission.new
      new_admission.name = new_admission_params[:name]
      new_admission.email = new_admission_params[:email]
      new_admission.parent_mobile = new_admission_params[:parent_mobile]
      new_admission.student_mobile = new_admission_params[:student_mobile]
      new_admission.batch = NewAdmission.batches[new_admission_params[:batch]]
      new_admission.rcc_branch = NewAdmission.rcc_branches[new_admission_params[:rcc_branch]]
      new_admission.course_id = course.id
      new_admission.gender = new_admission_params[:gender]
      new_admission.student_id = new_admission_params[:student_id]
      new_admission.prev_receipt_number = new_admission_params[:prev_receipt_number]

      if new_admission.save
        new_admission.in_progress!
        redirect_to get_eazy_pay_url(new_admission, course)
      else
        flash[:error] = new_admission.errors.full_messages
        redirect_back(fallback_location: '/new-admission')
      end
    else
      flash[:error] = errors
      flash[:error] << "Please try again, please fill form completely."
      if @student.present?
        redirect_to '/pay-installment' and return
      end
      redirect_back(fallback_location: '/new-admission')
    end
  end

  def get_eazy_pay_due_amount_url(new_admission, student)
    eazy_pay_url(
          new_admission.payment_id,
          student.pending_amount.to_s.to_i,
          "#{new_admission.parent_mobile}#{new_admission.id}",
          !new_admission.student_id.present?
        )
  end

  def get_eazy_pay_url(new_admission, course)
    # eazy_pay_url_v2(
    #   new_admission.payment_id,
    #   get_fees(new_admission_params[:batch], course, new_admission.student_id.present?, new_admission.rcc_branch),
    #   "#{new_admission.parent_mobile}#{new_admission.id}",
    #   !new_admission.student_id.present?,
    #   new_admission
    # )
    
    eazy_pay_url(
      new_admission.payment_id,
      get_fees(new_admission_params[:batch], course, new_admission.student_id.present?, new_admission.rcc_branch),
      "#{new_admission.parent_mobile}#{new_admission.id}",
      !new_admission.student_id.present?
    )
  end

  def get_fees(batch, course, is_installment = false, rcc_branch = nil)
    if batch == "12th"
      return 12_000 if course.name == "phy"
      return 12_000 if course.name == "chem"
      return 6_000 if is_installment && course.name == "bio"
      return 9_000 if course.name == "bio"
      return 24_000 if course.name == "pc"
      return 21_000 if course.name == "pb"
      return 21_000 if course.name == "cb"
      return 33_000 if course.name == "pcb"
    end
    if batch == 'repeater'
      return 12_000 if course.name == "phy"
      return 12_000 if course.name == "chem"
      return 12_000 if course.name == "bio"

      return 24_000 if course.name == "pc"
      return 24_000 if course.name == "pb"
      return 24_000 if course.name == "cb"
      return 25_000 if course.name == "pcb"
    end
    if batch == '11th' && rcc_branch == 'nanded'
      return 15_000 if course.name == "phy"
    end
    course.fees
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
        if @new_admission.student_id.present?
          student = Student.find_by(id: @new_admission.student_id)
          if student.present?
            PaymentTransaction.create(
              student_id: student.id,
              amount: @new_admission.payment_callback_data['Total Amount'].to_f,
              reference_number: @new_admission.payment_id,
              new_admission_id: @new_admission.id
            )

            # remove due information on successful payment.
            pending_fees = PendingFee.find_by(student_id: student.id, paid: false, amount: @new_admission.payment_callback_data['Total Amount'].to_f)
            if pending_fees.present?
              pending_fees.paid = true
              pending_fees.reference_no = @new_admission.id
              pending_fees.save
            end

            batches = get_batches(@new_admission.rcc_branch, @new_admission.course, @new_admission.batch)
            if batches.present?
              # student.batches.destroy_all
              student.new_admission_id = @new_admission.id
              student.save
              student.batches << batches
              # student.roll_number = suggest_online_roll_number(Org.first, batches, true)
              if @new_admission.batch == 'repeater'
                student.roll_number = suggest_rep_online_roll_number
                student.suggested_roll_number = suggest_rep_online_roll_number
              else
                student.roll_number = suggest_tw_online_roll_number
                student.suggested_roll_number = suggest_tw_online_roll_number
              end
              student.api_key = student.api_key + '+1'
              student.app_login = false
              student.save
            end
            send_sms(student, true)
          end
        else
          pay_transaction = PaymentTransaction.find_by(
            reference_number: @new_admission.payment_id,
            new_admission_id: @new_admission.id
          ) rescue nil

          if pay_transaction.blank?
            std = add_student(@new_admission)
            @new_admission.student_id = std.id
            @new_admission.save
            PaymentTransaction.create(
              student_id: std.id,
              amount: @new_admission.payment_callback_data['Total Amount'].to_f,
              reference_number: @new_admission.payment_id,
              new_admission_id: @new_admission.id
            ) rescue nil
          end
        end
      else
        @new_admission && @new_admission.failure!
      end
      @new_admission.save
    end
    @erorr_info = error_info[@error_code]
  end

  private

    INITIAL_TW_ROLL_NUMBER = 51200
    def suggest_tw_online_roll_number
      online_s_ids = NewAdmission.where(error_code: ['E000', 'E006']).where(batch: NewAdmission.batches['12th']).where.not(student_id: nil).pluck(:student_id)
      rn = Student.where(id: online_s_ids).where.not(new_admission_id: nil).pluck(:suggested_roll_number).reject(&:blank?).max rescue nil
      return rn + 1 if rn

      INITIAL_TW_ROLL_NUMBER
    end

    INITIAL_RP_ROLL_NUMBER = 6001
    def suggest_rep_online_roll_number
      online_s_ids = NewAdmission.where(error_code: ['E000', 'E006']).where(batch: NewAdmission.batches['repeater']).where.not(student_id: nil).pluck(:student_id)
      rn = Student.where(id: online_s_ids).where.not(new_admission_id: nil).pluck(:suggested_roll_number).reject(&:blank?).max rescue nil
      return rn + 1 if rn

      INITIAL_RP_ROLL_NUMBER
    end

    INITIAL_ONLINE_ROLL_NUMBER = 1100
    def suggest_online_roll_number(org, batch, is_12th=false)
      new_11_batch_ids = [46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59]
      s_ids = StudentBatch.where(batch_id: new_11_batch_ids).pluck(:student_id)
      rn = Student.where(id: s_ids).where.not(new_admission_id: nil).pluck(:suggested_roll_number).reject(&:blank?).max rescue nil
      return rn + 1 if rn

      INITIAL_ONLINE_ROLL_NUMBER
    end

    def add_student(na)
      org = Org.first
      batches = get_batches(na.rcc_branch, na.course, na.batch)

      if @new_admission.batch == 'repeater'
        roll_number = suggest_rep_online_roll_number
      else
        roll_number = suggest_online_roll_number(org, batches.first)
      end

      email = "#{roll_number}-#{na.id}-#{na.parent_mobile}@rcc.com"
      student = Student.find_or_initialize_by(email: email)
      student.roll_number = roll_number
      student.suggested_roll_number = roll_number
      student.name = na.name
      student.mother_name = "-"
      student.gender = na.gender == 'male' ? 0 : 1
      student.student_mobile = na.student_mobile
      student.parent_mobile = na.parent_mobile
      student.category_id = 1
      student.password = na.parent_mobile
      student.raw_password = na.parent_mobile
      student.org_id = org.id
      student.new_admission_id = na.id
      student.save

      student.batches << batches

      send_sms(student)
      return student
    end

    SMS_USER_NAME = "divyesh92@yahoo.com"
    SMS_PASSWORD = "myadmin"

    def send_sms(student, is_installment=false)
      require 'net/http'
      strUrl = "https://www.businesssms.co.in/SMS.aspx"; # Base URL
      if is_installment
        strUrl = strUrl+"?ID=#{SMS_USER_NAME}&Pwd=#{SMS_PASSWORD}&PhNo=+91"+student.parent_mobile+"&Text="+installment_sms_text(student)+"";
      else
        strUrl = strUrl+"?ID=#{SMS_USER_NAME}&Pwd=#{SMS_PASSWORD}&PhNo=+91"+student.parent_mobile+"&Text="+sms_text(student)+"";
      end
      uri = URI(strUrl)
      puts Net::HTTP.get(uri)

      strUrl = "https://www.businesssms.co.in/SMS.aspx"; # Base URL
      if is_installment
        strUrl = strUrl+"?ID=#{SMS_USER_NAME}&Pwd=#{SMS_PASSWORD}&PhNo=+91"+student.student_mobile.to_s+"&Text="+installment_sms_text(student)+"";
      else
        strUrl = strUrl+"?ID=#{SMS_USER_NAME}&Pwd=#{SMS_PASSWORD}&PhNo=+91"+student.student_mobile.to_s+"&Text="+sms_text(student)+"";
      end
      uri = URI(strUrl)
      puts Net::HTTP.get(uri)
    end

    def installment_sms_text(student)
      "Dear Students, Welcome in the world of  RCC.

      Your Installment is processed, successfully.

      Name: #{student.name}
      New Batch: #{student.batches.pluck(:name).join(",")}

      your Login details are
      Roll Number: #{student.roll_number}
      Parent Mobile: #{student.parent_mobile}

      Remove your app and Reinstall it from
      https://play.google.com/store/apps/details?id=com.at_and_a.rcc_new

      Thank you, Team RCC"
    end

    def sms_text(student)
      "Dear Students, Welcome in the world of  RCC.

      Your admission is confirmed.

      Name: #{student.name}
      Course: #{student.batches.pluck(:name).join(",")}

      your Login details are
      Roll Number: #{student.roll_number}
      Parent Mobile: #{student.parent_mobile}

      Download App from given link
      https://play.google.com/store/apps/details?id=com.at_and_a.rcc_new"
    end

    def get_batches(rcc_branch, course, batch)
      if batch == '11th'
        if rcc_branch == "latur"
          return Batch.where(name: 'B-2_Latur_11th_PCB_2020') if course.name == 'pcb'
          return Batch.where(name: 'B-2_Latur_11th_Phy_2020') if course.name == 'phy'
          return Batch.where(name: 'B-2_Latur_11th_Chem_2020') if course.name == 'chem'
          return Batch.where(name: 'B-2_Latur_11th_Bio_2020') if course.name == 'bio'
          return Batch.where(name: 'B-2_Latur_11th_PC_2020') if course.name == 'pc'
          return Batch.where(name: 'B-2_Latur_11th_PB_2020') if course.name == 'pb'
          return Batch.where(name: 'B-2_Latur_11th_CB_2020') if course.name == 'cb'
        else
          return Batch.where(name: 'B-2_Nanded_11th_PCB_2020') if course.name == 'pcb'
          return Batch.where(name: 'Nanded 11th Phy (VIP) 2020') if course.name == 'phy'
          return Batch.where(name: 'B-2_Nanded_11th_Chem_2020') if course.name == 'chem'
          return Batch.where(name: 'B-2_Nanded_11th_Bio_2020') if course.name == 'bio'
          return Batch.where(name: 'B-2_Nanded_11th_PC_2020') if course.name == 'pc'
          return Batch.where(name: 'B-2_Nanded_11th_PB_2020') if course.name == 'pb'
          return Batch.where(name: 'B-2_Nanded_11th_CB_2020') if course.name == 'cb'
        end
      elsif batch == 'repeater'
        org = Org.first
        batch_name = rcc_branch == "latur" ?
          "Ltr-REP-#{course.name.upcase}-2020" :
          "Ned-REP-#{course.name.upcase}-2020"

        Batch.find_or_create_by(org_id: org.id, name: batch_name)
        Batch.where(org_id: org.id, name: batch_name)
      else
        if rcc_branch == "latur"
          return Batch.where(name: 'Ltr_12th-PCB_2020-21') if course.name == 'pcb'
          return Batch.where(name: 'Ltr_12th-Physics_2020-21') if course.name == 'phy'
          return Batch.where(name: 'Ltr_12th-Chemistry_2020-21') if course.name == 'chem'
          return Batch.where(name: 'Ltr_12th-Biology_2020-21') if course.name == 'bio'
          return Batch.where(name: 'Ltr_12th-PC_2020-21') if course.name == 'pc'
          return Batch.where(name: 'Latur-12th Phy + Bio 2021') if course.name == 'pb'
          return Batch.where(name: 'Latur-12th Chem + Bio 2021') if course.name == 'cb'
        else
          return Batch.where(name: 'Ned_12th-PCB_2020-21') if course.name == 'pcb'
          return Batch.where(name: 'Ned_12th-Physics_2020-21') if course.name == 'phy'
          return Batch.where(name: 'Ned_12th-Chemistry_2020-21') if course.name == 'chem'
          return Batch.where(name: 'Ned_12th-Biology_2020-21') if course.name == 'bio'
          return Batch.where(name: 'Ned_12th-PC_2020-21') if course.name == 'pc'
          return Batch.where(name: 'Ned-12th Phy + Bio 2021') if course.name == 'pb'
          return Batch.where(name: 'Ned-12th Chem + Bio 2021') if course.name == 'cb'
        end
      end
    end

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

    def encrypt_v2(data)
      key = "2777771948205271"
      cipher = OpenSSL::Cipher.new("AES-128-ECB")
      cipher.encrypt()
      cipher.key = key
      crypt = cipher.update(data) + cipher.final

      crypt_string = (Base64.encode64(crypt))
      crypt_string
    end

    def eazy_pay_url(record_id, amount, parent_mobile, add_processing_fees=true)
      icid = "270074"
      reference_number = record_id    # db id for the the admission table
      sub_merchant_id = parent_mobile     #student roll _number

      transaction_amount = (add_processing_fees ? amount + 120 : amount).to_s

      mandatory_fields = "#{reference_number}|#{sub_merchant_id}|#{transaction_amount}"
      return_url = "https://exams.smartclassapp.in/admission-done"

      plain_url = "https://eazypay.icicibank.com/EazyPG?merchantid=#{icid}&mandatory fields=#{mandatory_fields}&optional fields=&returnurl=#{(return_url)}&Reference No=#{(reference_number)}&submerchantid=#{(sub_merchant_id)}&transaction amount=#{(transaction_amount)}&paymode=#{('9')}"

      "https://eazypay.icicibank.com/EazyPG?merchantid=#{icid}&mandatory%20fields=#{encrypt(mandatory_fields)}&optional%20fields=&returnurl=#{encrypt(return_url)}&Reference No=#{encrypt(reference_number)}&submerchantid=#{encrypt(sub_merchant_id)}&transaction%20amount=#{encrypt(transaction_amount)}&paymode=#{encrypt('9')}"
    end


    def eazy_pay_url_v2(record_id, amount, parent_mobile, add_processing_fees=true, new_admission)
      icid = "274822"
      reference_number = record_id    # db id for the the admission table
      sub_merchant_id = parent_mobile     #student roll _number

      transaction_amount = (add_processing_fees ? amount + 120 : amount).to_s

      mandatory_fields = "#{reference_number}|#{sub_merchant_id}|#{transaction_amount}|Renukai Chemistry Classes|#{new_admission.name}|#{new_admission.email.downcase}|#{new_admission.parent_mobile}|#{new_admission.parent_mobile}|#{new_admission.rcc_branch}|#{new_admission.course&.name}|#{new_admission.batch}|NA|NA"

      return_url = "https://exams.smartclassapp.in/admission-done"

      # plain_url = "https://eazypay.icicibank.com/EazyPG?merchantid=#{icid}&mandatory fields=#{mandatory_fields}&optional fields=&returnurl=#{(return_url)}&Reference No=#{(reference_number)}&submerchantid=#{(sub_merchant_id)}&transaction amount=#{(transaction_amount)}&paymode=#{('9')}"

      "https://eazypay.icicibank.com/EazyPG?merchantid=#{icid}&mandatory%20fields=#{encrypt_v2(mandatory_fields)}&optional%20fields=&returnurl=#{encrypt_v2(return_url)}&Reference No=#{encrypt_v2(reference_number)}&submerchantid=#{encrypt_v2(sub_merchant_id)}&transaction%20amount=#{encrypt_v2(transaction_amount)}&paymode=#{encrypt_v2('9')}"
    end

    def new_admission_params
      params.permit(:name, :email, :parent_mobile, :student_mobile, :batch, :gender, :rcc_branch, :student_id, :prev_receipt_number, course: [])
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
