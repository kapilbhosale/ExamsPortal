# == Schema Information
#
# Table name: fees_templates
#
#  id          :bigint(8)        not null, primary key
#  description :string
#  heads       :jsonb
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  org_id      :bigint(8)
#
# Indexes
#
#  index_fees_templates_on_org_id  (org_id)
#

class FeesTemplate < ApplicationRecord
  belongs_to :org

  def total_amount
    heads.pluck("amount").sum
  end
end

# FeesTemplate.create({
#   org_id: 1,
#   name: "Template-11",
#   description: "Template for 11th students 2023-24",
#   :heads => [{
#     "cgst" => 9,
#     "head" => "Tution Fees",
#     "sgst" => 9,
#     "amount" => 24000
#   },{
#     "cgst" => 2.5,
#     "head" => "Book Fees",
#     "sgst" => 2.5,
#     "amount" => 10000
#   }]
# })

# *****