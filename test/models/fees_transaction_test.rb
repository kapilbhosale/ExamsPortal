# == Schema Information
#
# Table name: fees_transactions
#
#  id                   :uuid             not null, primary key
#  academic_year        :string
#  comment              :string
#  deleted_at           :datetime
#  discount_amount      :decimal(, )      default(0.0)
#  imported             :boolean          default(FALSE)
#  is_headless          :boolean          default(FALSE)
#  mode                 :string
#  next_due_date        :date
#  paid_amount          :decimal(, )      default(0.0)
#  payment_details      :jsonb
#  receipt_number       :string           not null
#  received_by          :string
#  remaining_amount     :decimal(, )      default(0.0)
#  token_of_the_day     :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  org_id               :bigint(8)
#  received_by_admin_id :integer
#  student_id           :bigint(8)
#
# Indexes
#
#  index_fees_transactions_on_deleted_at  (deleted_at)
#  index_fees_transactions_on_org_id      (org_id)
#  index_fees_transactions_on_student_id  (student_id)
#

require 'test_helper'

class FeesTransactionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
