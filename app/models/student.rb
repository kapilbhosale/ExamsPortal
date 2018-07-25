# == Schema Information
#
# Table name: students
#
#  id             :bigint(8)        not null, primary key
#  address        :text
#  college        :string
#  date_of_birth  :date
#  gender         :integer          default(0)
#  mother_name    :string
#  name           :string           not null
#  parent_mobile  :string(20)       not null
#  photo          :string
#  roll_number    :integer          not null
#  ssc_marks      :float
#  student_mobile :string(20)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  category_id    :bigint(8)
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

  def self.suggest_roll_number
    self.last&.roll_number.to_i + 1
  end
end
