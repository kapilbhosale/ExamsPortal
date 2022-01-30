# == Schema Information
#
# Table name: batches
#
#  id             :bigint(8)        not null, primary key
#  disable_count  :integer          default(0)
#  name           :string
#  students_count :integer          default(0)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  batch_group_id :integer
#  org_id         :integer          default(0)
#
# Indexes
#
#  index_batches_on_batch_group_id  (batch_group_id)
#  index_batches_on_org_id          (org_id)
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

  has_many :batch_micro_payments
  has_many :micro_payments, through: :batch_micro_payments

  has_many :batch_banners
  has_many :banners, through: :batch_banners

  # after_create :create_push_notif_topic

  # def create_push_notif_topic
  #   fcm = FCM.new(org.fcm_server_key)
  #   topic = name.parameterize
  #   response = fcm.topic_subscription(topic, registration_id)
  # end

  def recount_disable
    student_ids = StudentBatch.where(batch_id: id).pluck(:student_id)
    self.disable_count = Student.where(id: student_ids, disable: true).count
    save
  end

  def self.all_batches
    Batch.all { |batch| [batch.id, batch.name] }
  end

  def self.re_count_students_all_batches
    Batch.all.each do |batch|
      batch.re_count_students
    end
  end

  def re_count_students
    self.students_count = students.count
    save
  end

  def self.get_jee_batches(rcc_branch, course, batch, na=nil)
    org = Org.first

    batch_name = rcc_branch == "latur" ?
      "Ltr-JEE-#{course.name.upcase}-2021" :
      "Ned-JEE-#{course.name.upcase}-2021"

    _batch = Batch.find_by(org_id: org.id, name: batch_name)
    if _batch.blank?
      admin = Admin.where(org_id: org.id).first
      batch_group = BatchGroup.find_or_create_by(name: "JEE-#{batch}-#{rcc_branch}-2021-2022", org_id: org.id)
      _batch = Batch.create(org_id: org.id, name: batch_name, batch_group_id: batch_group.id)
      AdminBatch.create(admin_id: admin.id, batch_id: _batch.id)
    end
    Batch.where(org_id: org.id, name: batch_name)
  end

  def self.get_saartni_batches(rcc_branch, course, batch, na=nil)
    org = Org.first

    batch_name = rcc_branch == "latur" ?
      "LTR-NEET-SAARTHI-2022" :
      "NED-NEET-SAARTHI-2022"

    _batch = Batch.find_by(org_id: org.id, name: batch_name)
    if _batch.blank?
      admin = Admin.where(org_id: org.id).first
      batch_group = BatchGroup.find_or_create_by(name: "SAARTHI-2022", org_id: org.id)
      _batch = Batch.create(org_id: org.id, name: batch_name, batch_group_id: batch_group.id)
      AdminBatch.create(admin_id: admin.id, batch_id: _batch.id)
    end
    Batch.where(org_id: org.id, name: batch_name)
  end

  def self.get_11th_batches(rcc_branch, course, batch, na=nil)
    org = Org.first

    if na&.jee?
      batch_name = rcc_branch == "latur" ?
        "Ltr-RCC-JEE-11-SET-22" :
        "Ned-RCC-JEE-11-SET-22"
    else
      batch_name = rcc_branch == "latur" ?
        "Ltr-RCC-NEET-11-SET-22" :
        "Ned-RCC-NEET-11-SET-22"
    end
    Batch.where(org_id: org.id, name: batch_name)
  end

  def self.get_11th_new_batches(rcc_branch, course, batch, na=nil)
    org = Org.first

    if na&.jee?
      batch_name = rcc_branch == "latur" ?
        "B3-LTR-11-REG-JEE-#{course.name.upcase}-21-22" :
        "B3-NED-11-REG-JEE-#{course.name.upcase}-21-22"
    else
      batch_name = rcc_branch == "latur" ?
        "B3-LTR-11-REG-NEET-#{course.name.upcase}-21-22" :
        "B3-NED-11-REG-NEET-#{course.name.upcase}-21-22"
    end

    Batch.where(org_id: org.id, name: batch_name)
  end

  def self.get_batches(rcc_branch, course, batch, na=nil)
    return nil if rcc_branch.nil? || course.nil? || batch.nil?

    return Batch.where(name: '7th-A') if batch == '7th'
    return Batch.where(name: '8th-A') if batch == '8th'
    return Batch.where(name: '9th-A') if batch == '9th'
    return Batch.where(name: '10th-A') if batch == '10th'

    if batch == '12th' && na&.jee? && (course.name == 'phy' || course.name == 'chem' || course.name == 'pc')
      return get_jee_batches(rcc_branch, course, batch, na)
    end

    if batch == '11th'
      get_11th_batches(rcc_branch, course, batch, na)
    elsif batch == '11th_new'
      get_11th_new_batches(rcc_branch, course, batch, na)
    elsif batch == 'neet_saarthi'
      get_saartni_batches(rcc_branch, course, batch, na)
    elsif batch == 'repeater'
      org = Org.first
      if na&.jee?
        batch_name = rcc_branch == "latur" ?
          "B2-REP-LTR-JEE-#{course.name.upcase}-21-22" :
          "B2-REP-NED-JEE-#{course.name.upcase}-21-22"
      else
        batch_name = rcc_branch == "latur" ?
          "B2-REP-LTR-NEET-#{course.name.upcase}-21-22" :
          "B2-REP-NED-NEET-#{course.name.upcase}-21-22"
      end
      Batch.find_or_create_by(org_id: org.id, name: batch_name)
      Batch.where(org_id: org.id, name: batch_name)
    elsif batch == 'test_series'
      org = Org.first
      batch_name = rcc_branch == "latur" ?
        "Ltr-TS-#{course.name.upcase}-2020" :
        "Ned-TS-#{course.name.upcase}-2020"
      Batch.find_or_create_by(org_id: org.id, name: batch_name)
      Batch.where(org_id: org.id, name: batch_name)
    elsif batch == 'crash_course'
      org = Org.first
      batch_name = rcc_branch == "latur" ?
        "Ltr-CC-#{course.name.upcase}-2021" :
        "Ned-CC-#{course.name.upcase}-2021"
      Batch.find_or_create_by(org_id: org.id, name: batch_name)
      Batch.where(org_id: org.id, name: batch_name)
    else
      org = Org.first
      batch_name = rcc_branch == "latur" ?
        "New12-Ltr-#{course.name.upcase}-2021-2022" :
        "New12-Ned-#{course.name.upcase}-2021-2022"
      Batch.find_or_create_by(org_id: org.id, name: batch_name)
      Batch.where(org_id: org.id, name: batch_name)
    end
  end
end

# ## Sample code to create batches and groups and admins

# org = Org.first
# courses = ["phy", "chem", "bio", "PC", "CB", "PB", "PCB"]
# batch_group = BatchGroup.find_or_create_by(name: 'B2-REP-LTR-21-22', org_id: org.id)
# ['LTR', 'NED'].each do |center|
#   courses.each do |course|
#     batch_name = "B2-REP-#{center}-NEET-#{course.upcase}-21-22"
#     batch = Batch.find_or_create_by(org_id: org.id, name: batch_name, batch_group_id: batch_group.id)
#     Admin.where(org_id: org.id).each do |admin|
#       AdminBatch.create(admin_id: admin.id, batch_id: batch.id)
#     end
#   end
# end

# courses = ["phy", "chem", "PC",]
# batch_group = BatchGroup.find_or_create_by(name: 'B2-REP-LTR-21-22', org_id: org.id)
# ['LTR', 'NED'].each do |center|
#   courses.each do |course|
#     batch_name = "B2-REP-#{center}-JEE-#{course.upcase}-21-22"
#     batch = Batch.find_or_create_by(org_id: org.id, name: batch_name, batch_group_id: batch_group.id)
#     Admin.where(org_id: org.id).each do |admin|
#       AdminBatch.create(admin_id: admin.id, batch_id: batch.id)
#     end
#   end
# end


# org = Org.first
# batch_group = BatchGroup.find_or_create_by(name: "REP-SET-21-22", org_id: org.id)
# ['Ltr', 'Ned'].each do |center|
#   batch_name = "#{center}-RCC-REP-SET-21-22"
#   batch = Batch.find_or_create_by(org_id: org.id, name: batch_name, batch_group_id: batch_group.id)
#   Admin.where(org_id: org.id).each do |admin|
#     AdminBatch.create(admin_id: admin.id, batch_id: batch.id)
#   end
# end

# org = Org.first
# batch_names = ["Ltr-RCC-JEE-11-SET-22", "Ned-RCC-JEE-11-SET-22", "Ltr-RCC-NEET-11-SET-22", "Ned-RCC-NEET-11-SET-22"]

# batch_names.each do |batch_name|
#   _batch = Batch.find_by(org_id: org.id, name: batch_name)
#   if _batch.blank?
#     admin = Admin.where(org_id: org.id).first
#     batch_group = BatchGroup.find_or_create_by(name: "11-RCC-SET-22", org_id: org.id)
#     _batch = Batch.create(org_id: org.id, name: batch_name, batch_group_id: batch_group.id)
#     AdminBatch.create(admin_id: admin.id, batch_id: _batch.id)
#   end
# end