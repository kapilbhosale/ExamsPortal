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
#   name: "T-56",
#   description: "Template for 11th & 12th PCB/PCM students 2023-24",
#   :heads => [{
#     "cgst" => 9,
#     "head" => "Tution Fees",
#     "sgst" => 9,
#     "amount" => 56_000
#   }]
# })

# FeesTemplate.create({
#   org_id: org.id,
#   name: "T-50",
#   description: "Template for 11th & 12th PC students 2023-24 + foudation 10th",
#   :heads => [{
#     "cgst" => 9,
#     "head" => "Tution Fees",
#     "sgst" => 9,
#     "amount" => 50_000
#   }]
# })


# FeesTemplate.create({
#   org_id: org.id,
#   name: "T-25",
#   description: "Template for 11th & 12th Single Subject students 2023-24",
#   :heads => [{
#     "cgst" => 9,
#     "head" => "Tution Fees",
#     "sgst" => 9,
#     "amount" => 25_000
#   }]
# })


# FeesTemplate.create({
#   org_id: org.id,
#   name: "T-1L",
#   description: "Template for 11th & 12th IIT center students 2023-24",
#   :heads => [{
#     "cgst" => 9,
#     "head" => "Tution Fees",
#     "sgst" => 9,
#     "amount" => 1_00_000
#   }]
# })


# FeesTemplate.create({
#   org_id: org.id,
#   name: "T-30",
#   description: "Template for Foundation - 6th",
#   :heads => [{
#     "cgst" => 9,
#     "head" => "Tution Fees",
#     "sgst" => 9,
#     "amount" => 30_000
#   }]
# })

# FeesTemplate.create({
#   org_id: org.id,
#   name: "T-35",
#   description: "Template for Foundation - 7th",
#   :heads => [{
#     "cgst" => 9,
#     "head" => "Tution Fees",
#     "sgst" => 9,
#     "amount" => 35_000
#   }]
# })

# FeesTemplate.create({
#   org_id: org.id,
#   name: "T-40",
#   description: "Template for Foundation - 8th",
#   :heads => [{
#     "cgst" => 9,
#     "head" => "Tution Fees",
#     "sgst" => 9,
#     "amount" => 40_000
#   }]
# })

# FeesTemplate.create({
#   org_id: org.id,
#   name: "T-45",
#   description: "Template for Foundation - 9th",
#   :heads => [{
#     "cgst" => 9,
#     "head" => "Tution Fees",
#     "sgst" => 9,
#     "amount" => 45_000
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
