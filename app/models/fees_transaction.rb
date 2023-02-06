# == Schema Information
#
# Table name: fees_transactions
#
#  id                   :uuid             not null, primary key
#  academic_year        :string
#  comment              :string
#  discount_amount      :decimal(, )      default(0.0)
#  mode                 :string
#  next_due_date        :date
#  paid_amount          :decimal(, )      default(0.0)
#  payment_details      :jsonb
#  receipt_number       :integer          not null
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
  # avaialbe to all devs, less is always good
  scope :lt_hundred, ->() { where('token_of_the_day < 100') }
  # available only to kapil, more is not good
  scope :gt_hundred, ->() { where('token_of_the_day >= 100') }

  scope :today, -> { where(created_at: DateTime.current.beginning_of_day..DateTime.current.end_of_day) }

  belongs_to :student
  belongs_to :org

  before_create :update_token_of_the_day
  before_create :update_receipt_number


  def self.student_fees_template_data(org_id, student_id)
    fees_transactions = FeesTransaction.current_year.where(org_id: org_id, student_id: student_id)
    return nil if fees_transactions.blank?

    paid_by_heads = {}
    fees_transactions.each do |fees_transaction|
      fees_transaction.payment_details['paid'].each do |head, details|
        paid_by_heads[head] ||= 0
        paid_by_heads[head] += details['paid'] + details['discount']
      end
    end
    current_template_id = fees_transactions.order(:created_at).last.payment_details.dig('template', 'id')
    fees_template = FeesTemplate.find_by(id: current_template_id).attributes

    fees_template['heads'].each do |head|
      paid_amount = paid_by_heads[head['head']].to_f
      head['amount'] = head['amount'] - paid_amount
    end
    fees_template
  end

  def as_json
    {
      date: created_at.strftime('%Y-%m-%d'),
      roll_number: student.roll_number,
      name: student.name,
      gender: student.gender == 0 ? 'Male' : 'Female' ,
      batch: student.batches.pluck('name').join(', '),
      receipt_number: receipt_number,
      paid_amount: paid_amount.to_f,
      base_fee: paid_amount + remaining_amount,
      cgst: payment_details.dig('totals', 'cgst').to_f,
      sgst: payment_details.dig('totals', 'sgst').to_f,
      remaining_amount: remaining_amount.to_f,
      discount_amount: discount_amount.to_f,
      discount_comment: comment
    }
  end

  private
  def update_receipt_number
    if token_of_the_day < 100
      self.receipt_number = (FeesTransaction.lt_hundred.order(:created_at).last&.receipt_number || 0) + 1
    else
      self.receipt_number = (FeesTransaction.gt_hundred.order(:created_at).last&.receipt_number || 0) + 1
    end
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
