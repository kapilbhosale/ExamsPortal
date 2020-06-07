# == Schema Information
#
# Table name: new_admissions
#
#  id                    :bigint(8)        not null, primary key
#  address               :text
#  batch                 :integer          default(NULL)
#  city                  :string
#  district              :string
#  email                 :string
#  error_code            :string
#  error_info            :string
#  first_name            :string
#  gender                :integer          default(NULL)
#  last_exam_percentage  :string
#  last_name             :string
#  middle_name           :string
#  name                  :string
#  parent_mobile         :string           not null
#  payment_callback_data :jsonb
#  payment_status        :integer          default("initial")
#  rcc_branch            :integer          default("latur")
#  school_name           :string
#  student_mobile        :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  course_id             :integer
#  payment_id            :string
#  reference_id          :string
#

class NewAdmission < ApplicationRecord

  belongs_to :course

  enum payment_status: {
    initial: 0,
    initiated: 1,
    in_progress: 2,
    success: 3,
    failure: 4
  }

  enum gender: { male: 1, female: 2, other: 3 }
  # enum course: { physics: 1, chemistry: 2, biology: 3, pcb: 4 }
  enum batch: { '11th': 1, '12th': 2, 'repeater': 3, 'crash_course': 4, 'foundation': 5 }

  enum rcc_branch: {latur: 0, nanded: 1}

  after_create :create_unique_payment_id
  after_create :create_unique_reference_id

  private

  def create_unique_payment_id
    self.payment_id = loop do
      payment_id = (SecureRandom.random_number * 10000000000000000).to_i
      break payment_id unless self.class.exists?(payment_id: payment_id)
    end
    save
  end

  def create_unique_reference_id
    self.reference_id = loop do
      reference_id = SecureRandom.uuid
      break reference_id unless self.class.exists?(reference_id: reference_id)
    end
    save
  end
end
