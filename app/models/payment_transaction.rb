# == Schema Information
#
# Table name: payment_transactions
#
#  id               :bigint(8)        not null, primary key
#  amount           :decimal(, )
#  reference_number :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  new_admission_id :integer
#  student_id       :bigint(8)
#
# Indexes
#
#  index_payment_transactions_on_student_id  (student_id)
#

class PaymentTransaction < ApplicationRecord
end
