# == Schema Information
#
# Table name: students
#
#  id             :bigint(8)        not null, primary key
#  roll_number    :integer          not null
#  name           :string           not null
#  mother_name    :string
#  date_of_birth  :date
#  gender         :integer          default(0)
#  ssc_marks      :float
#  student_mobile :string(20)
#  parent_mobile  :string(20)       not null
#  address        :text
#  college        :string
#  photo          :string
#  category_id    :bigint(8)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Student < ApplicationRecord
  belongs_to :category
  has_many   :student_batches
  has_many   :batches, through: :student_batches

  validates  :roll_number, :name, :parent_mobile, presence: true
  validates  :gender, numericality: {only_integer: true}
  validates  :ssc_marks, numericality: true
end
