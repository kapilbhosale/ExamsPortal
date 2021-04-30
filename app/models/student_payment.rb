# == Schema Information
#
# Table name: student_payments
#
#  id               :bigint(8)        not null, primary key
#  amount           :decimal(, )
#  raw_data         :jsonb
#  status           :integer          default("initial")
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  micro_payment_id :bigint(8)
#  rz_order_id      :string
#  student_id       :bigint(8)
#
# Indexes
#
#  index_student_payments_on_micro_payment_id  (micro_payment_id)
#  index_student_payments_on_student_id        (student_id)
#

class StudentPayment < ApplicationRecord
  belongs_to :micro_payment
  belongs_to :student, optional: true

  enum status: {
    initial: 0,
    initiated: 1,
    in_progress: 2,
    success: 3,
    failure: 4
  }
end
