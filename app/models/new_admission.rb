# == Schema Information
#
# Table name: new_admissions
#
#  id                    :bigint(8)        not null, primary key
#  address               :text
#  batch                 :integer          default(NULL)
#  city                  :string
#  course_type           :integer          default("neet")
#  district              :string
#  email                 :string
#  error_code            :string
#  error_info            :string
#  extra_data            :jsonb
#  fees                  :decimal(, )      default(0.0)
#  first_name            :string
#  free                  :boolean          default(FALSE)
#  gender                :integer          default(NULL)
#  last_exam_percentage  :string
#  last_name             :string
#  middle_name           :string
#  name                  :string
#  parent_mobile         :string           not null
#  payment_callback_data :jsonb
#  payment_status        :integer          default("initial")
#  prev_receipt_number   :text
#  rcc_branch            :integer          default("latur")
#  school_name           :string
#  status                :string           default("default")
#  student_mobile        :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  course_id             :integer
#  payment_id            :string
#  reference_id          :string
#  rz_order_id           :string
#  student_id            :integer
#
# Indexes
#
#  index_new_admissions_on_course_id     (course_id)
#  index_new_admissions_on_payment_id    (payment_id)
#  index_new_admissions_on_reference_id  (reference_id)
#  index_new_admissions_on_rz_order_id   (rz_order_id)
#

class NewAdmission < ApplicationRecord

  belongs_to :course, optional: true

  enum payment_status: {
    initial: 0,
    initiated: 1,
    in_progress: 2,
    success: 3,
    failure: 4
  }

  enum status: {
    default: 'default',
    started: 'started',
    done: 'done'
  }

  enum gender: { male: 1, female: 2, other: 3 }
  # enum course: { physics: 1, chemistry: 2, biology: 3, pcb: 4 }
  enum batch: {
    '11th': 1,
    '12th': 2,
    'repeater': 3,
    'crash_course': 4,
    'foundation': 5,
    'test_series': 6,
    'crash_course': 7,
    '7th': 101,
    '8th': 102,
    '9th': 103,
    '10th': 104,
    '11th_new': 10,
    'neet_saarthi': 11,
    '12th_set': 12,
    'set_aurangabad': 13,
    '11th_set': 14,
    '12th_set_1': 15,
    'test-series': 16
  }
  enum course_type: { neet: 0, jee: 1 }
  enum rcc_branch: { latur: 0, nanded: 1, aurangabad: 2, akola: 3, pune: 4, kolhapur: 5, pimpri: 6 }

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
