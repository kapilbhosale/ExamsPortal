require 'openssl'
require 'base64'
require 'razorpay'

class Students::AdmissionsController < ApplicationController
  layout false, only: [:show, :foundation_show, :pay_installment, :create_installment, :registration_form, :registration_confirmation, :register]
  MERCHANT_ID = "3300260987"
  skip_before_action :verify_authenticity_token, only: [:admission_done, :create]
  before_action :set_org

  # PAYMENT_MODE = "icici-bank"
  PAYMENT_MODE = "razor-pay"

  def show
    redirect_to '/' unless ['exams', 'rcc'].include?(request.subdomain)
    @errors = []
    @is_set = params[:set] == 'true'
    @student_id = params[:student_id]
    # @url = eazy_pay_url
  end

  def register
    @errors = []
    @student = Student.where(org_id: @org.id, parent_mobile: registration_params[:parent_mobile], student_mobile: registration_params[:student_mobile]).first
    batch_id = registration_params[:course_type] == 'pcb' ? 781 : 782
    @batch = Rails.env.production? ? Batch.find(batch_id) : Batch.last


    if @student.present?
      unless @student.batches.ids.include?(@batch.id)
        student.batches << @batch
      end

      render 'registration_confirmation' and return
    end

    last_roll_num = Student.where(org_id: @org.id).includes(:batches).where(batches: {id: @batch.id}).maximum(:roll_number) || 10_000
    if @errors.empty?
      @student = Student.create({
        org_id: @org.id,
        roll_number: last_roll_num + 1,
        name: registration_params[:name],
        gender: registration_params[:gender] == 'male' ? 0 : 1,
        student_mobile: registration_params[:student_mobile],
        parent_mobile: registration_params[:parent_mobile],
        email: registration_params[:email],
        password: registration_params[:parent_mobile],
        raw_password: registration_params[:parent_mobile],
        email: "#{@org.id}-#{registration_params[:student_mobile]}-#{registration_params[:parent_mobile]}@#{@org.subdomain}.eduaakar.com"
      })
      if @student.errors.blank?
        @student.batches << @batch
      else
        flash[:error] = @student.errors.full_messages
        render 'registration_form' and return
      end
    end

    render 'registration_confirmation'
  end

  def foundation_show
    redirect_to '/' unless ['exams', 'rcc'].include?(request.subdomain)
    @errors = []
  end

  def pay_installment
    redirect_to '/' unless ['exams', 'rcc'].include?(request.subdomain)
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
    is_set = params[:set] == 'true'

    if student.blank?
      flash[:error] = "Invalid student id, please contact admin."
      redirect_back(fallback_location: '/')
    end

    new_admission = NewAdmission.new
    new_admission.name = student.name
    new_admission.email = student.email
    new_admission.parent_mobile = student.parent_mobile
    new_admission.student_mobile = student.student_mobile
    new_admission.student_id = student.id
    new_admission.fees = student.pending_amount.to_s.to_i

    new_admission.extra_data = { is_set: true } if is_set

    if new_admission.fees <= 0
      flash[:error] = "No pending fees for the student."
      redirect_back(fallback_location: '/') and return
    end

    if new_admission.save
      new_admission.in_progress!
      if PAYMENT_MODE == 'razor-pay'
        # when we use razorpay
        redirect_to initiate_pay_path({id: new_admission.id}) and return
      else
        # when we use regular payments from ICICI
        redirect_to get_eazy_pay_due_amount_url(new_admission, student)
      end
    else
      flash[:error] = new_admission.errors.full_messages
      redirect_back(fallback_location: '/')
    end
  end

  def print_receipt
    @new_admission = NewAdmission.find_by(reference_id: params[:reference_id])
    @fees = @new_admission.fees.to_f
    @processing_fees = @new_admission.student_id.present? ? 0 : 120
    render pdf: "Payment Receipt",
            template: "/students/admissions/receipt.pdf.erb",
            locals: {students: {}},
            footer: { font_size: 9, left: DateTime.now.strftime("%d-%B-%Y %I:%M%p"), right: 'Page [page] of [topage]' }
  end

  def create
    errors = []
    params[:course] = ['pcb'] if params[:batch] == 'set_aurangabad'
    params[:course] = ['pcb'] if params[:batch] == '11th_set'
    params[:course] = ['pcb'] if params[:batch] == '12th_set'
    params[:course] = ['pcb'] if params[:batch] == '12th_set_1'

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

    unless ['test-series', '11th_new' , '12th', 'repeater', '11th_set', '12th_set'].include?(params[:batch])
      errors << "Invalid Admission data, please try agian."
    end

    if errors.blank?
      selected_courses = new_admission_params.delete(:course)
      course = Course.get_course(selected_courses)

      if ['11th_set', '11th', 'neet_saarthi', '12th_set', '12th_set_1', 'set_aurangabad'].include?(new_admission_params[:batch])
        new_admission = NewAdmission.where(
          parent_mobile: new_admission_params[:parent_mobile],
          student_mobile: new_admission_params[:student_mobile],
          free: true,
          batch: NewAdmission.batches[new_admission_params[:batch]]
        ).where('created_at > ?', Date.parse("10-dec-2023")).order(id: :desc)&.last
        if new_admission.present?
          redirect_to rcc_set_path_url({id: new_admission.reference_id}) and return
        end
      end

      new_admission = NewAdmission.new
      new_admission.name = new_admission_params[:name]
      new_admission.email = new_admission_params[:email]
      new_admission.parent_mobile = new_admission_params[:parent_mobile]
      new_admission.student_mobile = new_admission_params[:student_mobile]
      new_admission.batch = NewAdmission.batches[new_admission_params[:batch]]
      new_admission.rcc_branch = NewAdmission.rcc_branches[new_admission_params[:rcc_branch]]
      new_admission.course_type = NewAdmission.course_types[new_admission_params[:course_type]]
      new_admission.course_id = course.id
      new_admission.gender = new_admission_params[:gender]
      new_admission.student_id = new_admission_params[:student_id]
      new_admission.prev_receipt_number = new_admission_params[:prev_receipt_number]
      new_admission.extra_data = {
        pay_type: params[:pay_type],
        is_set: params[:is_set],
        set_center_11th: params[:set_center_11th],
        set_sub_center_11th: params[:set_sub_center_11th],
        taluka: params[:taluka],
        district: params[:district],
        board: params[:board]
      }
      new_admission.fees = get_fees(new_admission_params[:batch], course, new_admission.student_id.present?, new_admission.rcc_branch, new_admission)

      if new_admission.save
        if ['11th_set', '11th', 'neet_saarthi', '12th_set', '12th_set_1', 'set_aurangabad'].include? new_admission.batch
          new_admission.free = true
          new_admission.in_progress!
          new_admission.save
          redirect_to rcc_set_path_url({id: new_admission.reference_id}) and return
        end

        new_admission.in_progress!
        if PAYMENT_MODE == 'razor-pay'
          # when we use razorpay
          redirect_to initiate_pay_path({id: new_admission.id}) and return
        else
          # when we use regular payments from ICICI
          redirect_to get_eazy_pay_url(new_admission, course)
        end
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
      get_fees(new_admission_params[:batch], course, new_admission.student_id.present?, new_admission.rcc_branch, new_admission),
      "#{new_admission.parent_mobile}#{new_admission.id}",
      !new_admission.student_id.present?
    )
  end

  def get_fees(batch, course, is_installment = false, rcc_branch = nil, new_admission = nil)
    return 10_000 if batch == '7th'
    return 10_000 if batch == '8th'
    return 12_000 if batch == '9th'
    return 12_000 if batch == '10th'
    return 5_000 if batch == 'test-series'

    if batch == 'repeater'
      if new_admission.extra_data.dig('pay_type') == 'installment'
        return 25_000
      else
        return 50_000 if ['pc'].include?(course.name)
        return 60_000 if ['pcb'].include?(course.name)
      end
    end

    if batch == '11th_new' || batch == '12th'
      if new_admission.extra_data.dig('pay_type') == 'installment'
        # return 15_000 if ['phy', 'chem', 'bio'].include?(course.name)

        if ['pc', 'pb', 'cb'].include?(course.name)
          return 25_000
        end

        if ['pcb', 'pcm'].include?(course.name)
          return 25_000 if rcc_branch == 'nanded'
          return 25_000 if rcc_branch == 'latur'
          return 30_000 if rcc_branch == 'aurangabad'
          return 25_000
        end

        return 40_000 if ['pcbm'].include?(course.name)
        return 25_000
      else
        # return 25_000 if ['phy', 'chem', 'bio'].include?(course.name)

        if ['pc'].include?(course.name)
          return 50_000
        end

        if ['pcb', 'pcm'].include?(course.name)
          if rcc_branch == 'nanded'
            return(course.name == 'pcm' ? 60_000 : 55_000)
          end
          return 60_000 if rcc_branch == 'latur'
          return 75_000 if rcc_branch == 'aurangabad'
          return 60_000
        end

        return 80_000 if ['pcbm'].include?(course.name)
        return 60_000
      end
    end

    if batch == 'crash_course'
      return 8_000 if course.name == "phy"
      return 8_000 if course.name == "chem"
      return 8_000 if course.name == "bio"
      return 15_000 if course.name == "pcb"

      return 12_000 if course.name == "pc"
      return 12_000 if course.name == "pb"
      return 12_000 if course.name == "cb"
    end
    1_00_000
  end

  def admission_done_set
    ref_id = '7c0a5337-61db-4055-a2c3-8f3b21438012'
    @new_admission = NewAdmission.find_by(reference_id: params[:id], free: true)
    @errors = []

    if @new_admission.present? && (@new_admission.batch == '11th_set' || @new_admission.default?)
      @new_admission.started!
      @new_admission.success!

      # TODO:: student registered in old batch, fails to avoid duplicates in set
      student = Student.where(
        parent_mobile: @new_admission.parent_mobile,
        student_mobile: @new_admission.student_mobile
      ).where('created_at > ?', Date.parse("10-dec-2023")).last

      # batches_rep_set_23_24 = ['LTR-REP-SET-2023-24', 'NED-REP-SET-2023-24', 'AUR-REP-SET-2023-24', 'PUNE-REP-SET-2023-24', 'AK-REP-SET-2023-24', 'KLH-REP-SET-2023-24', 'PMP-REP-SET-2023-24']
      # batches_set_11_p3 = ["11-SET-2-april-23-(jee)", "11-SET-2-april-23-(neet)"]
      test_series_batch_ids = [972, 977]
      set_batch_ids_11th_23_24 = [986, 987]
      set_batch_ids_12th_23_24 = [988, 989]

      student_batch_ids = student&.batches&.ids || []
      if student.blank? ||
          @new_admission.batch == 'test-series' && (student_batch_ids & test_series_batch_ids).blank? ||
          @new_admission.batch == '11th_set' && (student_batch_ids & set_batch_ids_11th_23_24).blank? ||
          @new_admission.batch == '12th_set' && (student_batch_ids & set_batch_ids_12th_23_24).blank?
        student = Student.add_student(@new_admission) rescue nil
      end

      if student.blank?
        flash[:errors] = "Error 102, please try agian later"
        @errors << "Error 102, please try agian later"
      else
        @student = student
        student.new_admission_id = @new_admission.id
        @new_admission.done!
        student.save
      end
    elsif @new_admission.started?
      @errors << "Admission already confirmed, Please check SMS for details"
    elsif @new_admission.done?
      @errors << "Admission already confirmed, Please check SMS for details"
    else
      @errors << "Error 101, please try agian later"
    end
  end

  def admission_done
    Rails.logger.info "PAYMENT**********"
    Rails.logger.info params
    Rails.logger.info "PAYMENT**********"
    @params = params
    @status = (params['Response Code'] == 'E000')
    @error_code = params['Response Code']
    @new_admission = NewAdmission.in_progress.find_by(payment_id: params['ReferenceNo'])

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

            batches = Batch.get_batches(@new_admission.rcc_branch, @new_admission.course, @new_admission.batch, @new_admission)
            student.new_admission_id = @new_admission.id
            student.save

            if batches.present?
              # student.batches.destroy_all
              student.batches << batches

              suggested_rn = RollNumberSuggestor.suggest_roll_number(@new_admission.batch)
              student.roll_number = suggested_rn
              student.suggested_roll_number = suggested_rn

              student.api_key = student.api_key + '+1'
              student.app_login = false
              student.save
            end
            student.send_sms(true)
          end
        else
          pay_transaction = PaymentTransaction.find_by(
            reference_number: @new_admission.payment_id,
            new_admission_id: @new_admission.id
          ) rescue nil

          if pay_transaction.blank?
            std = Student.add_student(@new_admission)
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

    def set_org
      @org = Org.find_by(subdomain: request.subdomain)
    end

    def registration_params
      params.permit(:name, :email, :parent_mobile, :student_mobile, :gender, :batch, :course_type)
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

      if parent_mobile[0..9] == '7588584810'
        transaction_amount = amount.to_s
      else
        transaction_amount = (add_processing_fees ? amount + 120 : amount).to_s
      end

      mandatory_fields = "#{reference_number}|#{sub_merchant_id}|#{transaction_amount}"
      return_url = "https://exams.smartclassapp.in/admission-done"

      plain_url = "https://eazypay.icicibank.com/EazyPG?merchantid=#{icid}&mandatory fields=#{mandatory_fields}&optional fields=&returnurl=#{(return_url)}&Reference No=#{(reference_number)}&submerchantid=#{(sub_merchant_id)}&transaction amount=#{(transaction_amount)}&paymode=#{('9')}"

      "https://eazypay.icicibank.com/EazyPG?merchantid=#{icid}&mandatory%20fields=#{encrypt(mandatory_fields)}&optional%20fields=&returnurl=#{encrypt(return_url)}&Reference No=#{encrypt(reference_number)}&submerchantid=#{encrypt(sub_merchant_id)}&transaction%20amount=#{encrypt(transaction_amount)}&paymode=#{encrypt('9')}"
    end


    def eazy_pay_url_v2(record_id, amount, parent_mobile, add_processing_fees=true, new_admission)
      icid = "274822"
      reference_number = record_id    # db id for the the admission table
      sub_merchant_id = parent_mobile     #student roll _number

      if parent_mobile[0..9] == '7588584810'
        transaction_amount = amount.to_s
      else
        transaction_amount = (add_processing_fees ? amount + 120 : amount).to_s
      end

      mandatory_fields = "#{reference_number}|#{sub_merchant_id}|#{transaction_amount}|Renukai Chemistry Classes|#{new_admission.name}|#{new_admission.email.downcase}|#{new_admission.parent_mobile}|#{new_admission.parent_mobile}|#{new_admission.rcc_branch}|#{new_admission.course&.name}|#{new_admission.batch}|NA|NA"

      return_url = "https://exams.smartclassapp.in/admission-done"

      # plain_url = "https://eazypay.icicibank.com/EazyPG?merchantid=#{icid}&mandatory fields=#{mandatory_fields}&optional fields=&returnurl=#{(return_url)}&Reference No=#{(reference_number)}&submerchantid=#{(sub_merchant_id)}&transaction amount=#{(transaction_amount)}&paymode=#{('9')}"

      "https://eazypay.icicibank.com/EazyPG?merchantid=#{icid}&mandatory%20fields=#{encrypt_v2(mandatory_fields)}&optional%20fields=&returnurl=#{encrypt_v2(return_url)}&Reference No=#{encrypt_v2(reference_number)}&submerchantid=#{encrypt_v2(sub_merchant_id)}&transaction%20amount=#{encrypt_v2(transaction_amount)}&paymode=#{encrypt_v2('9')}"
    end

    def new_admission_params
      params.permit(:name, :course_type, :email, :parent_mobile, :student_mobile, :batch, :gender, :rcc_branch, :student_id, :prev_receipt_number, course: [])
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
