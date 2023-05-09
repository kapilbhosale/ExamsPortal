# == Schema Information
#
# Table name: batches
#
#  id             :bigint(8)        not null, primary key
#  config         :jsonb
#  disable_count  :integer          default(0)
#  end_time       :datetime
#  klass          :string
#  name           :string
#  start_time     :datetime
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

  has_many :batch_fees_templates
  has_many :fees_templates, through: :batch_fees_templates

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

  def self.get_rep_set_batches_23_24(rcc_branch, course, batch, na=nil)
    org = Org.first

    center_prefix = get_center_prefix(rcc_branch)
    batch_name = "#{center_prefix}-REP-SET-2023-24"

    _batch = Batch.find_by(org_id: org.id, name: batch_name)
    if _batch.blank?
      batch_group = BatchGroup.find_or_create_by(name: "REP-SET-2023-24", org_id: org.id)
      _batch = Batch.create(org_id: org.id, name: batch_name, batch_group_id: batch_group.id)
      Admin.where(org_id: org.id).each do |admin|
        AdminBatch.create(admin_id: admin.id, batch_id: _batch.id)
      end
    end
    Batch.where(org_id: org.id, name: batch_name)
  end

  def self.get_12th_set_batches_23_24(rcc_branch, course, batch, na=nil)
    org = Org.first

    case rcc_branch
      when 'latur'
        batch_name = "LTR-12-SET-2023-24"
      when 'nanded'
        batch_name = "NED-12-SET-2023-24"
      when 'aurangabad'
        batch_name = "AUR-12-SET-2023-24"
      else
        batch_name = "LTR-12-SET-2023-24"
    end

    _batch = Batch.find_by(org_id: org.id, name: batch_name)
    if _batch.blank?
      batch_group = BatchGroup.find_or_create_by(name: "12-SET-2023-24", org_id: org.id)
      _batch = Batch.create(org_id: org.id, name: batch_name, batch_group_id: batch_group.id)
      Admin.where(org_id: org.id).each do |admin|
        AdminBatch.create(admin_id: admin.id, batch_id: _batch.id)
      end
    end
    Batch.where(org_id: org.id, name: batch_name)
  end

  def self.get_11th_set_batches(rcc_branch, course, batch, na=nil)
    org = Org.first

    batch_name = "11-SET-2-april-23-(#{na.course_type})"

    _batch = Batch.find_by(org_id: org.id, name: batch_name)
    if _batch.blank?
      batch_group = BatchGroup.find_or_create_by(name: "11-SET-2023-24(phase2)", org_id: org.id)
      _batch = Batch.create(org_id: org.id, name: batch_name, batch_group_id: batch_group.id)
      Admin.where(org_id: org.id).each do |admin|
        AdminBatch.create(admin_id: admin.id, batch_id: _batch.id)
      end
    end
    Batch.where(org_id: org.id, name: batch_name)
  end

  def self.get_set_aug_batches(rcc_branch, course, batch, na=nil)
    org = Org.first
    batch_name = na.course_type == 'jee' ? "AUG-RCC-JEE-11-SET-22" : "AUG-RCC-NEET-11-SET-22"

    _batch = Batch.find_by(org_id: org.id, name: batch_name)
    if _batch.blank?
      admin = Admin.where(org_id: org.id).first
      batch_group = BatchGroup.find_or_create_by(name: "AUG-SET-11", org_id: org.id)
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

  def self.get_12th_batches(rcc_branch, course, batch, na=nil)
    org = Org.first

    return Batch.where(org_id: org.id, name: "B1-12-REG-PCM-22-23") if course.name.upcase == "PCM"
    return Batch.where(org_id: org.id, name: "B1-12-REG-PCBM-22-23") if course.name.upcase == "PCBM"

    if na&.jee?
      batch_name = rcc_branch == "latur" ?
        "B1-LTR-12-REG-JEE-#{course.name.upcase}-22-23" :
        "B1-NED-12-REG-JEE-#{course.name.upcase}-22-23"
    else
      batch_name = rcc_branch == "latur" ?
        "B1-LTR-12-REG-NEET-#{course.name.upcase}-22-23" :
        "B1-NED-12-REG-NEET-#{course.name.upcase}-22-23"
    end

    Batch.where(org_id: org.id, name: batch_name)
  end

  def get_repeater_batches(rcc_branch, course, batch, na)
    org = Org.first

    case rcc_branch
      when 'latur'
        batch_name = "LTR-REP-#{course.name.upcase}-2022-23"
      when 'nanded'
        batch_name = "NED-REP-#{course.name.upcase}-2022-23"
      when 'aurangabad'
        batch_name = "AUR-REP-#{course.name.upcase}-2022-23"
      else
        batch_name = "LTR-REP-#{course.name.upcase}-2022-23"
    end

    _batch = Batch.find_by(org_id: org.id, name: batch_name)
    Batch.where(org_id: org.id, name: batch_name)
  end

  def self.get_11th_new_batches(rcc_branch, course, batch, na=nil)
    org = Org.first

    if rcc_branch == "aurangabad"
      batch_name = "B1-11-AUG-2022-23"
    else
      return Batch.where(org_id: org.id, name: "B1-11-REG-PCM-22-23") if course.name.upcase == "PCM"
      return Batch.where(org_id: org.id, name: "B1-11-REG-PCBM-22-23") if course.name.upcase == "PCBM"

      if na&.jee?
        batch_name = rcc_branch == "latur" ?
          "B1-LTR-11-REG-JEE-#{course.name.upcase}-22-23" :
          "B1-NED-11-REG-JEE-#{course.name.upcase}-22-23"
      else
        batch_name = rcc_branch == "latur" ?
          "B1-LTR-11-REG-NEET-#{course.name.upcase}-22-23" :
          "B1-NED-11-REG-NEET-#{course.name.upcase}-22-23"
      end
    end

    Batch.where(org_id: org.id, name: batch_name)
  end

  def self.get_center_prefix(rcc_branch)
    return 'LTR' if rcc_branch == 'latur'
    return 'NED' if rcc_branch == 'nanded'
    return 'AUR' if rcc_branch == 'aurangabad'
    return 'PUNE' if rcc_branch == 'pune'
    return 'AK' if rcc_branch == 'akola'
    return 'KLH' if rcc_branch == 'kolhapur'
    return 'PMP' if rcc_branch == 'pimpri'

    'LTR'
  end


  def self.get_12th_batches_23_24(rcc_branch, course, batch, na=nil)
    org = Org.first

    center_prefix = get_center_prefix(rcc_branch)
    course_type = na.course_type&.upcase || 'NEET'

    batch_name = "B1-#{center_prefix}-12-REG-#{course_type}-#{course.name.upcase}-23-24"

    _batch = Batch.find_by(org_id: org.id, name: batch_name)
    if _batch.blank?
      batch_group = BatchGroup.find_or_create_by(name: "12th-REG-2023-24", org_id: org.id)
      _batch = Batch.create(org_id: org.id, name: batch_name, batch_group_id: batch_group.id)
      Admin.where(org_id: org.id).each do |admin|
        AdminBatch.create(admin_id: admin.id, batch_id: _batch.id)
      end
    end
    Batch.where(org_id: org.id, name: batch_name)
  end

  def self.get_batches(rcc_branch, course, batch, na=nil)
    return nil if rcc_branch.nil? || course.nil? || batch.nil?

    return Batch.where(name: '7th-A') if batch == '7th'
    return Batch.where(name: '8th-A') if batch == '8th'
    return Batch.where(name: '9th-A') if batch == '9th'
    return Batch.where(name: '10th-A') if batch == '10th'

    # if batch == '12th' && na&.jee? && (course.name == 'phy' || course.name == 'chem' || course.name == 'pc')
    #   return get_jee_batches(rcc_branch, course, batch, na)
    # end

    if batch == '11th'
      get_11th_batches(rcc_branch, course, batch, na)
    elsif batch == '12th'
      get_12th_batches_23_24(rcc_branch, course, batch, na)
    elsif batch == '11th_new'
      get_11th_new_batches(rcc_branch, course, batch, na)
    elsif batch == '12th_set' # 12th set is used neet saarthi 2023 for now
      get_rep_set_batches_23_24(rcc_branch, course, batch, na)
      # get_saarthi_batches_23_24(rcc_branch, course, batch, na)
    elsif batch == '12th_set_1' # 12th set is used neet saarthi 2023 for now
      get_12th_set_batches_23_24(rcc_branch, course, batch, na)
    elsif batch == '11th_set' # 12th set is used for repeaters set
      get_11th_set_batches(rcc_branch, course, batch, na)
    elsif batch == 'set_aurangabad'
      get_set_aug_batches(rcc_branch, course, batch, na)
    elsif batch == 'repeater'
      get_repeater_batches(rcc_branch, course, batch, na)
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

  def delete_batch_and_associated_data
    batch_id = id
    student_ids = StudentBatch.where(batch_id: batch_id).pluck(:student_id)

    # verify this before running
    other_batch_student_ids = StudentBatch.all.pluck(:student_id) - student_ids
    student_ids = student_ids - other_batch_student_ids

    student_ids.each_slice(1000) do |student_ids_slice|
      se_ids = StudentExam.where(student_id: student_ids_slice).pluck(:id)
      StudentExamSummary.where(student_exam_id: se_ids).delete_all
      StudentExamAnswer.where(student_exam_id: se_ids).delete_all
    end
    StudentExam.where(student_id: student_ids).delete_all

    StudentVideoFolder.where(student_id: student_ids).delete_all
    StudentExamSync.where(student_id: student_ids).delete_all
    PendingFee.where(student_id: student_ids).delete_all
    NewAdmission.where(student_id: student_ids).delete_all
    BatchStudyPdf.where(batch_id: batch_id).delete_all

    ExamBatch.where(batch_id: batch_id).delete_all
    BatchZoomMeeting.where(batch_id: batch_id).delete_all
    BatchVideoLecture.where(batch_id: batch_id).delete_all

    notif_ids = BatchNotification.where(batch_id: batch_id).pluck(:notification_id)
    Notification.where(id: notif_ids).delete_all

    BatchNotification.where(batch_id: batch_id).delete_all
    BatchBanner.where(batch_id: batch_id).delete_all

    ProgressReport.where(student_id: student_ids).delete_all

    StudentBatch.where(batch_id: batch_id).delete_all
    Batch.where(id: batch_id).delete_all
    Student.where(id: student_ids).delete_all
    print '.'
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

# org = Org.first
# batch_group = BatchGroup.find_or_create_by(name: "12th-RCC-SET-22-23", org_id: org.id)
# ['NEET', 'JEE'].each do |nj|
#   ['Ltr', 'Ned'].each do |center|
#     batch_name = "#{center}-RCC-#{nj}-12-SET-22"
#     batch = Batch.find_or_create_by(org_id: org.id, name: batch_name, batch_group_id: batch_group.id)
#     Admin.where(org_id: org.id).each do |admin|
#       AdminBatch.create(admin_id: admin.id, batch_id: batch.id)
#     end
#   end
# end

# org = Org.first
# courses = ["phy", "chem", "bio", "PC", "CB", "PB", "PCB", "PCM", "PCBM"]
# batch_group = BatchGroup.find_or_create_by(name: "B1-12th-22-23", org_id: org.id)
# ['NEET', 'JEE'].each do |nj|
#   ['LTR', 'NED'].each do |center|
#     courses.each do |course|
#       batch_name = "B1-#{center}-12-REG-#{nj}-#{course.upcase}-22-23"
#       batch = Batch.find_or_create_by(org_id: org.id, name: batch_name, batch_group_id: batch_group.id)
#       Admin.where(org_id: org.id).each do |admin|
#         AdminBatch.create(admin_id: admin.id, batch_id: batch.id)
#       end
#     end
#   end
# end


# org = Org.first
# batch_group = BatchGroup.find_or_create_by(name: "LTR-REP-2022-23", org_id: org.id)
# ["LTR-REP-PCB-2022-23", "LTR-REP-PC-2022-23"].each do |batch_name|
#   batch = Batch.find_or_create_by(org_id: org.id, name: batch_name, batch_group_id: batch_group.id)

#   Admin.where(org_id: org.id).each do |admin|
#     AdminBatch.create(admin_id: admin.id, batch_id: batch.id)
#   end
# end

# batch_group = BatchGroup.find_or_create_by(name: "NED-REP-2022-23", org_id: org.id)
# ["NED-REP-PCB-2022-23", "NED-REP-PC-2022-23"].each do |batch_name|
#   batch = Batch.find_or_create_by(org_id: org.id, name: batch_name, batch_group_id: batch_group.id)

#   Admin.where(org_id: org.id).each do |admin|
#     AdminBatch.create(admin_id: admin.id, batch_id: batch.id)
#   end
# end

# batch_group = BatchGroup.find_or_create_by(name: "AUR-REP-2022-23", org_id: org.id)
# ["AUR-REP-PCB-2022-23", "AUR-REP-PC-2022-23"].each do |batch_name|
#   batch = Batch.find_or_create_by(org_id: org.id, name: batch_name, batch_group_id: batch_group.id)

#   Admin.where(org_id: org.id).each do |admin|
#     AdminBatch.create(admin_id: admin.id, batch_id: batch.id)
#   end
# end
