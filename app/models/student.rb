require 'csv'
# == Schema Information
#
# Table name: students
#
#  id                     :bigint(8)        not null, primary key
#  address                :text
#  api_key                :string
#  app_login              :boolean          default(FALSE)
#  college                :string
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  date_of_birth          :date
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  fcm_token              :string
#  gender                 :integer          default(0)
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  mother_name            :string
#  name                   :string           not null
#  parent_mobile          :string(20)       not null
#  photo                  :string
#  raw_password           :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  roll_number            :integer          not null
#  sign_in_count          :integer          default(0), not null
#  ssc_marks              :float
#  student_mobile         :string(20)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  category_id            :bigint(8)
#  org_id                 :integer          default(0)
#
# Indexes
#
#  index_students_on_category_id    (category_id)
#  index_students_on_name           (name)
#  index_students_on_parent_mobile  (parent_mobile)
#

class Student < ApplicationRecord
  belongs_to :category, optional: true
  has_many   :student_batches
  has_many   :batches, through: :student_batches

  validates  :roll_number, :name, :parent_mobile, presence: true
  validates  :gender, numericality: {only_integer: true}
  validates  :ssc_marks, numericality: true, allow_nil: true
  validates  :photo, file_size: { less_than: 2.megabytes }

  mount_uploader :photo, PhotoUploader

  devise :database_authenticatable, :recoverable, :rememberable,
  :trackable, :validatable, authentication_keys: [:login]

  after_save :set_api_key

  attr_writer :login

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

  def self.suggest_roll_number
    self.last&.roll_number.to_i + 1
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

  def set_api_key
    return if api_key.present?

    self.api_key = generated_api_key
    save
  end

  def generated_api_key
    Digest::MD5.hexdigest "#{roll_number}-#{parent_mobile}"
    # SecureRandom.uuid.gsub(/\-/,'')
  end
end
