require 'csv'
# == Schema Information
#
# Table name: students
#
#  id                     :bigint(8)        not null, primary key
#  access_type            :integer          default(0)
#  address                :text
#  api_key                :string
#  app_login              :boolean          default(FALSE)
#  app_reset_count        :integer          default(0)
#  brand                  :string
#  college                :string
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  data                   :jsonb
#  date_of_birth          :date
#  deleted_at             :datetime
#  deviceName             :string
#  deviceUniqueId         :string
#  disable                :boolean          default(FALSE)
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  exam_hall              :string
#  fcm_token              :string
#  gender                 :integer          default(0)
#  id_card                :jsonb
#  intel_score            :integer
#  is_laptop_login        :boolean          default(FALSE)
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  manufacturer           :string
#  mother_name            :string
#  name                   :string           not null
#  parent_mobile          :string(20)       not null
#  photo                  :string
#  raw_password           :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  rfid_card_number       :string
#  roll_number            :integer          not null
#  sign_in_count          :integer          default(0), not null
#  ssc_marks              :float
#  student_mobile         :string(20)
#  suggested_roll_number  :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  category_id            :bigint(8)
#  new_admission_id       :integer
#  org_id                 :integer          default(0)
#
# Indexes
#
#  index_students_on_api_key                        (api_key)
#  index_students_on_category_id                    (category_id)
#  index_students_on_deleted_at                     (deleted_at)
#  index_students_on_name                           (name)
#  index_students_on_org_id                         (org_id)
#  index_students_on_parent_mobile                  (parent_mobile)
#  index_students_on_roll_number                    (roll_number)
#  index_students_on_roll_number_and_parent_mobile  (roll_number,parent_mobile) UNIQUE
#

class Student < ApplicationRecord
  require 'net/http'
  acts_as_paranoid
  audited

  belongs_to :category, optional: true
  has_many   :student_batches, dependent: :destroy
  has_many   :batches, through: :student_batches
  belongs_to :org
  has_many   :pending_fees
  has_many   :form_data
  has_many   :fees_transactions
  has_one    :omr_student, class_name: 'Omr::Student'

  validates  :roll_number, :name, :parent_mobile, presence: true
  validates  :gender, numericality: {only_integer: true}
  validates  :ssc_marks, numericality: true, allow_nil: true
  validates  :photo, file_size: { less_than: 2.megabytes }
  validates  :parent_mobile, uniqueness: { scope: :roll_number }

  # add this code to new RCC server.
  # validates  :parent_mobile, uniqueness: { scope: :student_mobile }
  # validates :roll_number, uniqueness: true

  mount_uploader :photo, PhotoUploader

  devise :database_authenticatable, :recoverable, :rememberable,
  :trackable, :validatable, authentication_keys: [:login]

  before_save :set_api_key

  ROLL_NUMBER_RANGE = (10_00_000..99_99_999)
  ROLL_NUMBER_RANGE_5_DIGITS = (10_000..99_999)

  attr_writer :login

  enum access_types: { not_set: 0, mobile: 1, laptop: 2 }

  # Override the destroy method
  def destroy
    raise ActiveRecord::ReadOnlyRecord, "Cannot destroy a record of YourModel"
  end

  # Override the delete method
  def delete
    raise ActiveRecord::ReadOnlyRecord, "Cannot delete a record of YourModel"
  end

  # Prevents the record from being deleted by delete_all
  def self.delete_all
    raise ActiveRecord::ReadOnlyRecord, "Cannot delete records of YourModel"
  end

  # Prevents the record from being destroyed by destroy_all
  def self.destroy_all
    raise ActiveRecord::ReadOnlyRecord, "Cannot destroy records of YourModel"
  end

  def login
    @login || self.roll_number || self.email
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h)
      .where(["roll_number = :value OR lower(email) = :value", { :value => login.downcase }])
    elsif conditions.has_key?(:roll_number) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

  def self.suggest_roll_number(org)
    self.where(org: org).last&.roll_number.to_i + 1
  end

  def self.to_csv
    CSV.generate(headers: true) do |csv|
      csv << ['Roll Number', 'Student Name', 'Email', 'password', 'Batch']

      Student.all.each do |student|
        csv << [
          student.roll_number,
          student.name,
          student.email,
          student.raw_password,
          student.batches.pluck(:name).join(' | ')
        ]
      end
    end
  end

  def reset_apps
    self.update!(
      app_login: false,
      is_laptop_login: false,
      deviceUniqueId: nil,
      deviceName: nil,
      manufacturer: nil,
      brand: nil,
      app_reset_count: self.app_reset_count + 1
    )
  end

  def self.add_student(na)
    # do not process add student against the na if its started or done
    return false if na.done?

    org = Org.first
    batches = Batch.get_batches(na.rcc_branch, na.course, na.batch, na)

    suggested_rn = RollNumberSuggestor.suggest_roll_number(na.batch, na)
    roll_number = suggested_rn

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

    student.send_sms if Rails.env.production?
    return student
  end

  def pending_amount
    amount = pending_fees.where(paid: false).last&.amount || 0
    amount > 0 ? amount : nil
  end

  def block_videos?
    pending_fees.where(paid: false).last&.block_videos == true
  end

  def set_api_key
    self.api_key = generated_api_key
  end

  def generated_api_key
    key = Digest::MD5.hexdigest "#{org_id}-#{roll_number}-#{parent_mobile}"
    # SecureRandom.uuid.gsub(/\-/,'')
    "#{key}-#{app_reset_count}"
  end

  def self.random_roll_number(digits=7)
    loop do
      number = rand(ROLL_NUMBER_RANGE) #(digits == 7 ? rand(ROLL_NUMBER_RANGE) : rand(ROLL_NUMBER_RANGE_5_DIGITS))
      break number unless self.exists?(roll_number: number)
    end
  end

  INITIAL_TW_ROLL_NUMBER = 60_000
  def self.suggest_tw_online_roll_number
    online_s_ids = NewAdmission.where(error_code: ['E000', 'E006', nil]).where(batch: NewAdmission.batches['12th']).where.not(student_id: nil).pluck(:student_id)
    rn = Student.where(id: online_s_ids).where.not(new_admission_id: nil).pluck(:suggested_roll_number).reject(&:blank?).max rescue nil

    return rn + 1 if rn

    INITIAL_TW_ROLL_NUMBER
  end

  INITIAL_RP_ROLL_NUMBER = 6001
  def self.suggest_rep_online_roll_number
    online_s_ids = NewAdmission.where(error_code: ['E000', 'E006', nil]).where(batch: NewAdmission.batches['repeater']).where.not(student_id: nil).pluck(:student_id)
    rn = Student.where(id: online_s_ids).where.not(new_admission_id: nil).pluck(:suggested_roll_number).reject(&:blank?).max rescue nil
    return rn + 1 if rn
    INITIAL_RP_ROLL_NUMBER
  end

  INITIAL_ONLINE_ROLL_NUMBER = 1100
  def self.suggest_online_roll_number(org, batch, is_12th=false)
    new_11_batch_ids = [46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59]
    s_ids = StudentBatch.where(batch_id: new_11_batch_ids).pluck(:student_id)
    rn = Student.where(id: s_ids).where.not(new_admission_id: nil).pluck(:suggested_roll_number).reject(&:blank?).max rescue nil
    return rn + 1 if rn

    INITIAL_ONLINE_ROLL_NUMBER
  end

  BASE_URL = "http://servermsg.com/api/SmsApi/SendSingleApi"

  def set_confirmation_sms(mobile_number)
    sms_user = "RCCLatur"
    sms_password = URI.encode_www_form_component(org.data['sms_settings']['password'])
    sender_id = "RCCLtr"
    template_id = '1007665462650104735'
    entity_id = '1001545918985192145'

    msg = "Dear Students/ Parents, \nFrom RCC Welcome in the world of Motegaonkar Sirs RCC. Your RCC-SET Scholarship Entrance Test Registration is Confirmed Roll No - #{roll_number.to_s.rjust(7, '0')} Parent Mobile No - #{parent_mobile} \nDownload App from Below link- https://play.google.com/store/apps/details?id=com.at_and_a.rcc_new&pcampaignid=web_share For Any Assistance Call - 9075 40 2222, 9075 39 2222 Team RCC"
    msg = URI.encode_www_form_component(msg)

    msg_url = "#{BASE_URL}?UserID=#{sms_user}&Password=#{sms_password}&SenderID=#{sender_id}&Phno=#{mobile_number}&Msg=#{msg}&EntityID=#{entity_id}&TemplateID=#{template_id}"
    encoded_uri = URI(msg_url)
    puts Net::HTTP.get(encoded_uri)
  end

  def rcc_admission_confirm_sms(mobile_number)
    sms_user = "RCCLatur"
    sms_password = URI.encode_www_form_component(org.data['sms_settings']['password'])
    sender_id = "RCCLtr"
    template_id = '1007270988222216500'
    entity_id = '1001545918985192145'

    msg = "Dear Student, \nFrom RCC \nWelcome in the world of RCC \nYour admission is confirmed \nRoll No - #{roll_number.to_s.rjust(7, '0')}\nParent Mob No - #{parent_mobile}\nDownload App from below link \nhttps://play.google.com/store/apps/details?id=com.at_and_a.rcc_new"
    msg = URI.encode_www_form_component(msg)

    msg_url = "#{BASE_URL}?UserID=#{sms_user}&Password=#{sms_password}&SenderID=#{sender_id}&Phno=#{mobile_number}&Msg=#{msg}&EntityID=#{entity_id}&TemplateID=#{template_id}"
    encoded_uri = URI(msg_url)
    puts Net::HTTP.get(encoded_uri)
  end

  def rcc_installment_sms(mobile_number)
    sms_user = "RCCLatur"
    sms_password = URI.encode_www_form_component(org.data['sms_settings']['password'])
    sender_id = "RCCLtr"
    template_id = '1007567986910703670'
    entity_id = '1001545918985192145'

    msg = "Dear Students, \nWelcome in the world of RCC. \nYour Installment is processed, successfully. \nName: #{name} \nCourse:#{batches.pluck(:name).join(",")} \nyour Login details are \nRoll Number: #{roll_number} \nParent Mobile: #{parent_mobile}\n Download App from given link \nhttps://play.google.com/store/apps/details?id=com.at_and_a.rcc_new"
    msg = URI.encode_www_form_component(msg)

    msg_url = "#{BASE_URL}?UserID=#{sms_user}&Password=#{sms_password}&SenderID=#{sender_id}&Phno=#{mobile_number}&Msg=#{msg}&EntityID=#{entity_id}&TemplateID=#{template_id}"
    encoded_uri = URI(msg_url)
    puts Net::HTTP.get(encoded_uri)
  end

  def send_sms(is_installment=false)
    # SET_BATCH_ID_MARKER
    if (batches.ids & [1186]).present?
      set_confirmation_sms(parent_mobile.to_s) if parent_mobile.present?
      set_confirmation_sms(student_mobile.to_s) if student_mobile.present?
    else
      if is_installment
        rcc_installment_sms(parent_mobile.to_s) if parent_mobile.present?
        rcc_installment_sms(student_mobile.to_s) if student_mobile.present?
      else
        rcc_admission_confirm_sms(parent_mobile.to_s) if parent_mobile.present?
        rcc_admission_confirm_sms(student_mobile.to_s) if student_mobile.present?
      end
    end
  end

  def generate_and_send_otp
    sms_user = "KALPAK01"
    sms_password = URI.encode_www_form_component("gjax3187GJ")
    sender_id = "ATASMS"
    template_id = '1007674069396942106'
    entity_id = '1001047216797018207'

    # what to send
    @otp = ROTP::TOTP.new(Base32.encode(parent_mobile), {interval: 1.day}).now
    msg = "Dear Student, your OTP for login (valid for 10 minutes) is - #{@otp} From ATASMS"
    msg = URI.encode_www_form_component(msg)

    msg_url = "#{BASE_URL}?UserID=#{sms_user}&Password=#{sms_password}&SenderID=#{sender_id}&Phno=#{parent_mobile}&Msg=#{msg}&EntityID=#{entity_id}&TemplateID=#{template_id}"
    encoded_uri = URI(msg_url)
    puts Net::HTTP.get(encoded_uri)

    if (parent_mobile != student_mobile)
      msg_url = "#{BASE_URL}?UserID=#{sms_user}&Password=#{sms_password}&SenderID=#{sender_id}&Phno=#{student_mobile}&Msg=#{msg}&EntityID=#{entity_id}&TemplateID=#{template_id}"
      encoded_uri = URI(msg_url)
      puts Net::HTTP.get(encoded_uri)
    end

    return @otp
  end

  def otp_sms_text(otp)
    "Dear Student, your OTP for login (valid for 10 minutes) is - #{otp} From ATASMS"
  end

  def self.import_hallticket_csv(path)
    if CSV.foreach(path, col_sep: "\t", headers: true).first.headers != ["Roll Number",
      "Name",
      "Exam Date & Time",
      "Parent mobile",
      "Student mobile",
      "course",
      "Board",
      "Exam Center",
      "Adress"]
      return {error: "Invalid CSV Headers"}
    end

    imported_count = 0
    CSV.foreach(path, col_sep: "\t", headers: true) do |row|
      student = Student.where(parent_mobile: row["Parent mobile"], roll_number: row["Roll Number"])
      if student.present?
        student.update_all(data: {
          center: row["Exam Center"],
          course: row["course"]&.upcase,
          school_name: "-",
          address: row["Adress"],
          board: row["Board"]&.upcase,
          exam_time: row["Exam Date & Time"],
          tag: '2023-24'
        })
        putc "."
        imported_count += 1
      end
    end

    return {imported_count: imported_count}
  end
end

# code to revemo duplicates.
# duplicates = Student.group(:roll_number, :parent_mobile).having('count(*) > 1').pluck(:roll_number, :parent_mobile)

# duplicates.each do |roll_number, parent_mobile|
#   Student.where(roll_number: roll_number, parent_mobile: parent_mobile).offset(1).delete_all
# end
