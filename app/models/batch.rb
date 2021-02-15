# == Schema Information
#
# Table name: batches
#
#  id             :bigint(8)        not null, primary key
#  name           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  batch_group_id :integer
#  org_id         :integer          default(0)
#

class Batch < ApplicationRecord
  has_many  :student_batches, dependent: :destroy
  has_many  :students, through: :student_batches, dependent: :destroy

  has_many :exams_batches
  has_many :exams, through: :exams_batches
  validates :name, presence: true

  has_many :batch_video_lectures
  has_many :video_lectures, through: :batch_video_lectures

  has_many :batch_study_pdfs
  has_many :study_pdfs, through: :batch_study_pdfs

  has_many :batch_notifications
  has_many :notifications, through: :batch_notifications

  has_many :admin_batches
  has_many :admins, through: :admin_batches

  belongs_to :batch_group, optional: true
  belongs_to :org

  def self.all_batches
    Batch.all { |batch| [batch.id, batch.name] }
  end

  def self.get_batches(rcc_branch, course, batch)
    return nil if rcc_branch.nil? || course.nil? || batch.nil?

    if batch == '11th'
      if rcc_branch == "latur"
        return Batch.where(name: 'B-2_Latur_11th_PCB_2020') if course.name == 'pcb'
        return Batch.where(name: 'B-2_Latur_11th_Phy_2020') if course.name == 'phy'
        return Batch.where(name: 'B-2_Latur_11th_Chem_2020') if course.name == 'chem'
        return Batch.where(name: 'B-2_Latur_11th_Bio_2020') if course.name == 'bio'
        return Batch.where(name: 'B-2_Latur_11th_PC_2020') if course.name == 'pc'
        return Batch.where(name: 'B-2_Latur_11th_PB_2020') if course.name == 'pb'
        return Batch.where(name: 'B-2_Latur_11th_CB_2020') if course.name == 'cb'
      else
        return Batch.where(name: 'B-2_Nanded_11th_PCB_2020') if course.name == 'pcb'
        return Batch.where(name: 'B-2_Nanded_11th_Phy_2020') if course.name == 'phy'
        return Batch.where(name: 'B-2_Nanded_11th_Chem_2020') if course.name == 'chem'
        return Batch.where(name: 'B-2_Nanded_11th_Bio_2020') if course.name == 'bio'
        return Batch.where(name: 'B-2_Nanded_11th_PC_2020') if course.name == 'pc'
        return Batch.where(name: 'B-2_Nanded_11th_PB_2020') if course.name == 'pb'
        return Batch.where(name: 'B-2_Nanded_11th_CB_2020') if course.name == 'cb'
      end
    elsif batch == 'repeater'
      org = Org.first
      batch_name = rcc_branch == "latur" ?
        "Ltr-REP-3-#{course.name.upcase}-2020" :
        "Ned-REP-3-#{course.name.upcase}-2020"
      Batch.find_or_create_by(org_id: org.id, name: batch_name)
      Batch.where(org_id: org.id, name: batch_name)
    else
      org = Org.first
      batch_name = rcc_branch == "latur" ?
        "New12-Ltr-#{course.name.upcase}-2021-2022" :
        "New12-Ned-#{course.name.upcase}-2021-2022"
      Batch.find_or_create_by(org_id: org.id, name: batch_name)
      Batch.where(org_id: org.id, name: batch_name)
      # if rcc_branch == "latur"
      #   return Batch.where(name: 'Ltr_12th-PCB_2020-21') if course.name == 'pcb'
      #   return Batch.where(name: 'Ltr_12th-Physics_2020-21') if course.name == 'phy'
      #   return Batch.where(name: 'Ltr_12th-Chemistry_2020-21') if course.name == 'chem'
      #   return Batch.where(name: 'Ltr_12th-Biology_2020-21') if course.name == 'bio'
      #   return Batch.where(name: 'Ltr_12th-PC_2020-21') if course.name == 'pc'
      #   return Batch.where(name: 'Latur-12th Phy + Bio 2021') if course.name == 'pb'
      #   return Batch.where(name: 'Latur-12th Chem + Bio 2021') if course.name == 'cb'
      # else
      #   return Batch.where(name: 'Ned_12th-PCB_2020-21') if course.name == 'pcb'
      #   return Batch.where(name: 'Ned_12th-Physics_2020-21') if course.name == 'phy'
      #   return Batch.where(name: 'Ned_12th-Chemistry_2020-21') if course.name == 'chem'
      #   return Batch.where(name: 'Ned_12th-Biology_2020-21') if course.name == 'bio'
      #   return Batch.where(name: 'Ned_12th-PC_2020-21') if course.name == 'pc'
      #   return Batch.where(name: 'Ned-12th Phy + Bio 2021') if course.name == 'pb'
      #   return Batch.where(name: 'Ned-12th Chem + Bio 2021') if course.name == 'cb'
      # end
    end
  end
end

## Sample code to create batches and groups and admins
#
# courses = ["phy", "chem", "bio", "pcb", "pc", "pb", "cb"]
# org = Org.first
# admin = Admin.where(org_id: org.id).first

# batch_group_ltr = BatchGroup.find_or_create_by(name: 'New12-Ltr-2021-2022', org_id: org.id)
# batch_group_ned = BatchGroup.find_or_create_by(name: 'New12-Ned-2021-2022', org_id: org.id)

# courses.each do |course|
#     batch_name = "New12-Ltr-#{course.upcase}-2021-2022"
#     batch = Batch.find_or_create_by(org_id: org.id, name: batch_name, batch_group_id: batch_group_ltr.id)
#     AdminBatch.create(admin_id: admin.id, batch_id: batch.id)

#     batch_name = "New12-Ltr-#{course.upcase}-2021-2022"
#     batch = Batch.find_or_create_by(org_id: org.id, name: batch_name, batch_group_id: batch_group_ned.id)
#     AdminBatch.create(admin_id: admin.id, batch_id: batch.id)
# end
