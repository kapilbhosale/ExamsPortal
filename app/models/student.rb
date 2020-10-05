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

  def pending_amount
    amount = pending_fees.where(paid: false).last&.amount || 0
    amount > 0 ? amount : nil
  end

  def set_api_key
    self.api_key = generated_api_key
  end

  def generated_api_key
    key = Digest::MD5.hexdigest "#{org_id}-#{roll_number}-#{parent_mobile}"
    # SecureRandom.uuid.gsub(/\-/,'')
    "#{key}-#{app_reset_count}"
  end
end
