# == Schema Information
#
# Table name: discounts
#
#  id               :bigint(8)        not null, primary key
#  amount           :decimal(, )
#  approved_by      :string
#  comment          :string
#  data             :jsonb
#  parent_mobile    :string
#  roll_number      :string
#  status           :string
#  student_mobile   :string
#  student_name     :string
#  type_of_discount :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  org_id           :bigint(8)
#
# Indexes
#
#  index_discounts_on_org_id                         (org_id)
#  index_discounts_on_roll_number_and_parent_mobile  (roll_number,parent_mobile)
#

class Discount < ApplicationRecord
  enum type_of_discount: { rcc_set: 'RCC_SET', fees_req: 'FEES_REQ', notes_req: 'NOTES_REQ', onetime: "ONETIME", special: "SPECIAL", other: 'OTHER' }
  enum status: { valid_discount: 'valid_discount', used_discount: 'used_discount', expired_discount: 'expired_discount' }

  def self.import_csv(csv_file_path)
    csv_text = File.read(csv_file_path)
    csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
    csv.each do |row|
      Discount.find_or_create_by({
        org_id: 1,
        type_of_discount: 'RCC_SET',
        student_name: row['name'],
        student_mobile: row['student_mobile'],
        parent_mobile: row['parent_mobile'],
        status: 'valid_discount',
        roll_number: row['roll_no'],
        comment: "RCC set discount, import 3 jan",
        approved_by: "SET exam 31/12/2023",
        amount: row['batch_fees'].to_i - row['amount_pay'].to_i,
        data: {
          amount_to_pay: row['amount_pay'],
          discount_percent: row['con_percent'],
          discount_amount: row['rcc_consession']
        }
      })
      putc "."
    end
  end
end
