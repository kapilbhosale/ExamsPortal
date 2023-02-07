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

# FeesTemplate.create({
#   org_id: org.id,
#   name: "LTR-11th+12th-PCB",
#   description: "Template for Latur 11th & 12th PCB students 2023-24",
#   :heads => [{
#     "cgst" => 9,
#     "head" => "Tution Fees",
#     "sgst" => 9,
#     "amount" => 120_000
#   }]
# })



# admin.name = "Vaibhav More"
# admin.email = 'vaibhav.more@rccpattern.com'
# admin.org_id = org.id
# admin.password = "RCC#765285"
# admin.roles = [:students, :batches]
# admin.save

# admin.name = "Gayatri Gajul"
# admin.email = 'gayatri.gajul@rccpattern.com'
# admin.org_id = org.id
# admin.password = "RCC#653985"
# admin.roles = [:students, :batches]
# admin.save

# -----
# admin.name = "Kishor Chevale"
# admin.email = 'kishor.chevale@rccpattern.com'
# admin.org_id = org.id
# admin.password = "RCC#654329"
# admin.roles = [:videos, :batches]
# admin.save
# admin.batches << Batch.all

# admin.name = "Ganesh Mohite"
# admin.email = 'ganesh.mohite@rccpattern.com'
# admin.org_id = org.id
# admin.password = "RCC#698734"
# admin.roles = [:videos, :exams, :pdfs, :batches, :notifications, :subjects]
# admin.save
# admin.batches << Batch.all

# admin.name = "Navthan Shinde"
# admin.email = 'navnath.shinde@rccpattern.com'
# admin.org_id = org.id
# admin.password = "RCC#653872"
# admin.roles = [:exams, :pdfs, :batches, :notifications]
# admin.save
# admin.batches << Batch.all

# ------

# admin.name = "Irfan Sayaad"
# admin.email = 'irgan.sayyad@rccpattern.com'
# admin.org_id = org.id
# admin.password = "RCC#654397"
# admin.roles = Admin::ROLES
# admin.save
# admin.batches << Batch.all

# org = Org.find 1
# admin = Admin.new
# admin.name = "Adinath Akanngire"
# admin.email = 'adinath.akanngire@rccpattern.com'
# admin.org_id = org.id
# admin.password = "RCC#543298"
# admin.roles = Admin::ROLES
# admin.save
# admin.batches << Batch.all

# -------
# org = Org.find 1
# admin = Admin.new
# admin.name = "Varsha More"
# admin.email = 'varsha.more@rccpattern.com'
# admin.org_id = org.id
# admin.password = "RCC#765498"
# admin.roles = [:students, :batches]
# admin.save
# admin.batches << Batch.all


# org = Org.find 1
# admin = Admin.new
# admin.name = "Saudagar Birajdar"
# admin.email = 'saudagar.birajdar@rccpattern.com'
# admin.org_id = org.id
# admin.password = "RCC#659826"
# admin.roles = [:students, :batches]
# admin.save
# admin.batches << Batch.all