# == Schema Information
#
# Table name: batch_micro_payments
#
#  id               :bigint(8)        not null, primary key
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  batch_id         :bigint(8)
#  micro_payment_id :bigint(8)
#
# Indexes
#
#  index_batch_micro_payments_on_batch_id          (batch_id)
#  index_batch_micro_payments_on_micro_payment_id  (micro_payment_id)
#

class BatchMicroPayment < ApplicationRecord
  belongs_to :batch
  belongs_to :micro_payment
end
