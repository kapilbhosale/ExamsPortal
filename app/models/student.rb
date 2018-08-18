require 'csv'
# == Schema Information
#
# Table name: students
#
#  id                     :bigint(8)        not null, primary key
#  address                :text
#  college                :string
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  date_of_birth          :date
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
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
  :trackable, :validatable

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
end
