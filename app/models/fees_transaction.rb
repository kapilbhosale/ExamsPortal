# == Schema Information
#
# Table name: fees_transactions
#
#  id               :bigint(8)        not null, primary key
#  academic_year    :string
#  comment          :string
#  discount_amount  :decimal(, )      default(0.0)
#  mode             :string
#  next_due_date    :date
#  paid_amount      :decimal(, )      default(0.0)
#  payment_details  :jsonb
#  receipt_number   :integer          not null
#  received_by      :string
#  remaining_amount :decimal(, )      default(0.0)
#  token_of_the_day :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  org_id           :bigint(8)
#  student_id       :bigint(8)
#
# Indexes
#
#  index_fees_transactions_on_org_id      (org_id)
#  index_fees_transactions_on_student_id  (student_id)
#

# {
#   template: {
#     id: 101,
#     name: "Template 01",
#     fees: [
#       {head: "Tution Fees", amount: 40_000, cgst: 9, sgst: 9},
#       {head: "Book Fees", amount: 10_000, cgst: 9, sgst: 9},
#       {head: "Other Fees", amount: 10_000, cgst: 9, sgst: 9}
#     ]
#   },
#   paid: {
#     "Tution Fees" => { paid: 10_000, discount: 0, fees: 1400, cgst: 180, sgst: 180 },
#     "Book Fees" => { paid: 2_000, discount: 0, fees: 1400, cgst: 180, sgst: 180 },
#   },
#   totals: {
#     paid: 13_600,
#     fees: 10_000,
#     cgst: 1_800,
#     cgst: 1_800,
#     discount: 10_000,
#     remaining: 20_000
#   }
# }

class FeesTransaction < ApplicationRecord
  CURRENT_ACADEMIC_YEAR = "2023-24"
  scope :current_year, ->() { where(academic_year: CURRENT_ACADEMIC_YEAR) }

  belongs_to :student
  belongs_to :org

  before_create :update_token_of_the_day
  before_create :update_receipt_number

  private
  def update_receipt_number
    self.receipt_number = (FeesTransaction.order(:id).last&.receipt_number || 0) + 1
  end

  def update_token_of_the_day
    if student.intel_score.present?
      self.token_of_the_day = student.intel_score
    else
      student.update(intel_score: (Student.count % 10) < 5 ? rand(1..99) : rand(100..200))
      self.token_of_the_day = student.intel_score
    end
  end
end
