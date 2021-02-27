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
#  date_of_birth          :date
#  deleted_at             :datetime
#  deviceName             :string
#  deviceUniqueId         :string
#  disable                :boolean          default(FALSE)
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  fcm_token              :string
#  gender                 :integer          default(0)
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
#  index_students_on_category_id    (category_id)
#  index_students_on_deleted_at     (deleted_at)
#  index_students_on_name           (name)
#  index_students_on_parent_mobile  (parent_mobile)
#

class Student < ApplicationRecord
  acts_as_paranoid

  belongs_to :category, optional: true
  has_many   :student_batches, dependent: :destroy
  has_many   :batches, through: :student_batches
  belongs_to :org
  has_many   :pending_fees

  validates  :roll_number, :name, :parent_mobile, presence: true
  validates  :gender, numericality: {only_integer: true}
  validates  :ssc_marks, numericality: true, allow_nil: true
  validates  :photo, file_size: { less_than: 2.megabytes }
  validates  :parent_mobile, uniqueness: { scope: :roll_number }

  mount_uploader :photo, PhotoUploader

  devise :database_authenticatable, :recoverable, :rememberable,
  :trackable, :validatable, authentication_keys: [:login]

  before_save :set_api_key

  attr_writer :login

  enum access_types: { not_set: 0, mobile: 1, laptop: 2 }

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
    org = Org.first
    batches = Batch.get_batches(na.rcc_branch, na.course, na.batch)

    if na.batch == 'repeater'
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

    student.send_sms
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

  SMS_USER_NAME = "maheshrccnanded@gmail.com"
  SMS_PASSWORD = "myadmin"

  def send_sms(is_installment=false)
    require 'net/http'
    strUrl = "https://www.businesssms.co.in/SMS.aspx"; # Base URL
    if is_installment
      strUrl = strUrl+"?ID=#{SMS_USER_NAME}&Pwd=#{SMS_PASSWORD}&PhNo=+91"+parent_mobile+"&Text="+installment_sms_text+"";
    else
      strUrl = strUrl+"?ID=#{SMS_USER_NAME}&Pwd=#{SMS_PASSWORD}&PhNo=+91"+parent_mobile+"&Text="+sms_text+"";
    end
    uri = URI(strUrl)
    puts Net::HTTP.get(uri)

    strUrl = "https://www.businesssms.co.in/SMS.aspx"; # Base URL
    if is_installment
      strUrl = strUrl+"?ID=#{SMS_USER_NAME}&Pwd=#{SMS_PASSWORD}&PhNo=+91"+student_mobile.to_s+"&Text="+installment_sms_text+"";
    else
      strUrl = strUrl+"?ID=#{SMS_USER_NAME}&Pwd=#{SMS_PASSWORD}&PhNo=+91"+student_mobile.to_s+"&Text="+sms_text+"";
    end
    uri = URI(strUrl)
    puts Net::HTTP.get(uri)
  end

  def installment_sms_text
    "Dear Students, Welcome in the world of  RCC.

    Your Installment is processed, successfully.

    Name: #{name}
    New Batch: #{batches.pluck(:name).join(",")}

    your Login details are
    Roll Number: #{roll_number}
    Parent Mobile: #{parent_mobile}

    Remove your app and Reinstall it from
    https://play.google.com/store/apps/details?id=com.at_and_a.rcc_new

    Thank you, Team RCC"
  end

  def sms_text
    "Dear Students, Welcome in the world of  RCC.

    Your admission is confirmed.

    Name: #{name}
    Course: #{batches.pluck(:name).join(",")}

    your Login details are
    Roll Number: #{roll_number}
    Parent Mobile: #{parent_mobile}

    Download App from given link
    https://play.google.com/store/apps/details?id=com.at_and_a.rcc_new"
  end
end
