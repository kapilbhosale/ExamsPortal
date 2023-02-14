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

# *********
# FeesTemplate.create({
#   org_id: org.id,
#   name: "LTR-11th-chem",
#   description: "Template for Latur 11th Checm students 2023-24",
#   :heads => [{
#     "cgst" => 9,
#     "head" => "Tution Fees",
#     "sgst" => 9,
#     "amount" => 25_000
#   }]
# })


# FeesTemplate.create({
#   org_id: org.id,
#   name: "LTR-11th-PC",
#   description: "Template for Latur 11th PC students 2023-24",
#   :heads => [{
#     "cgst" => 9,
#     "head" => "Tution Fees",
#     "sgst" => 9,
#     "amount" => 50_000
#   }]
# })

# FeesTemplate.create({
#   org_id: org.id,
#   name: "LTR-11th-PCB",
#   description: "Template for Latur 11th PCB students 2023-24",
#   :heads => [{
#     "cgst" => 9,
#     "head" => "Tution Fees",
#     "sgst" => 9,
#     "amount" => 60_000
#   }]
# })
# *********
# FeesTemplate.create({
#   org_id: org.id,
#   name: "LTR-12th-chem",
#   description: "Template for Latur 12th Checm students 2023-24",
#   :heads => [{
#     "cgst" => 9,
#     "head" => "Tution Fees",
#     "sgst" => 9,
#     "amount" => 25_000
#   }]
# })


# FeesTemplate.create({
#   org_id: org.id,
#   name: "LTR-12th-PC",
#   description: "Template for Latur 12th PC students 2023-24",
#   :heads => [{
#     "cgst" => 9,
#     "head" => "Tution Fees",
#     "sgst" => 9,
#     "amount" => 50_000
#   }]
# })

# FeesTemplate.create({
#   org_id: org.id,
#   name: "LTR-12th-PCB",
#   description: "Template for Latur 12th PCB students 2023-24",
#   :heads => [{
#     "cgst" => 9,
#     "head" => "Tution Fees",
#     "sgst" => 9,
#     "amount" => 60_000
#   }]
# })
# *********
# FeesTemplate.create({
#   org_id: org.id,
#   name: "LTR-rep-chem",
#   description: "Template for Latur rep Checm students 2023-24",
#   :heads => [{
#     "cgst" => 9,
#     "head" => "Tution Fees",
#     "sgst" => 9,
#     "amount" => 25_000
#   }]
# })


# FeesTemplate.create({
#   org_id: org.id,
#   name: "LTR-rep-PC",
#   description: "Template for Latur rep PC students 2023-24",
#   :heads => [{
#     "cgst" => 9,
#     "head" => "Tution Fees",
#     "sgst" => 9,
#     "amount" => 50_000
#   }]
# })

# FeesTemplate.create({
#   org_id: org.id,
#   name: "LTR-rep-PCB",
#   description: "Template for Latur rep PCB students 2023-24",
#   :heads => [{
#     "cgst" => 9,
#     "head" => "Tution Fees",
#     "sgst" => 9,
#     "amount" => 60_000
#   }]
# })


# *****
# org = Org.find 1

# FeesTemplate.create({
#   org_id: org.id,
#   name: "11+12-PCB-54 (2023-24)",
#   description: "Template for 11th & 12th PCB students 2023-24",
#   :heads => [{
#     "cgst" => 9,
#     "head" => "Tution Fees",
#     "sgst" => 9,
#     "amount" => 54_000
#   }]
# })

# FeesTemplate.create({
#   org_id: org.id,
#   name: "11+12-PC-50 (2023-24)",
#   description: "Template for 11th & 12th PC students 2023-24",
#   :heads => [{
#     "cgst" => 9,
#     "head" => "Tution Fees",
#     "sgst" => 9,
#     "amount" => 50_000
#   }]
# })


# FeesTemplate.create({
#   org_id: org.id,
#   name: "11+12-Chem-25 (2023-24)",
#   description: "Template for 11th & 12th Chem students 2023-24",
#   :heads => [{
#     "cgst" => 9,
#     "head" => "Tution Fees",
#     "sgst" => 9,
#     "amount" => 25_000
#   }]
# })


# org = Org.find 1
# admin = Admin.new
# admin.name = "Devne sir"
# admin.email = 'devne@konale-eduaakar.com'
# admin.org_id = org.id
# admin.password = "KONALE#239634"
# admin.roles = [:students, :batches, :payments, :notes]
# admin.save
# admin.batches << Batch.where(org_id: org.id)