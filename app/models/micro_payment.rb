# == Schema Information
#
# Table name: micro_payments
#
#  id                 :bigint(8)        not null, primary key
#  active             :boolean          default(TRUE)
#  amount             :decimal(, )
#  link               :string           not null
#  min_payable_amount :decimal(, )
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  org_id             :bigint(8)
#
# Indexes
#
#  index_micro_payments_on_link    (link) UNIQUE
#  index_micro_payments_on_org_id  (org_id)
#

class MicroPayment < ApplicationRecord
  has_many :batch_micro_payments
  has_many :batches, through: :batch_micro_payments
  has_many :student_payments

  belongs_to :org
end
