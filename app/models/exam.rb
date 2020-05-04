# == Schema Information
#
# Table name: exams
#
#  id              :bigint(8)        not null, primary key
#  description     :text
#  exam_type       :integer          default("jee")
#  name            :string           not null
#  negative_marks  :integer          default(-1), not null
#  no_of_questions :integer
#  positive_marks  :integer          default(4), not null
#  publish_result  :boolean          default(FALSE), not null
#  published       :boolean
#  show_exam_at    :datetime
#  time_in_minutes :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_exams_on_name  (name)
#

class Exam < ApplicationRecord
  validates_presence_of :name, :no_of_questions, :time_in_minutes

  has_many :exam_questions, dependent: :destroy
  has_many :questions, through: :exam_questions, dependent: :destroy

  has_many :exam_sections, dependent: :destroy
  has_many :sections, through: :exam_sections, dependent: :destroy

  has_many :exam_batches
  has_many :batches, through: :exam_batches

  enum exam_type: { jee: 0, cet: 1, other: 2 }

  after_create :send_push_notifications

  # has_one :style, as: :component, dependent: :destroy

  def appeared_student_ids
    StudentExam.where(exam: self).pluck(:student_id)
  end

  def un_appeared_student_ids
    total_student_ids - appeared_student_ids
  end

  def total_student_ids
    batches.map(&:student_ids).flatten
  end

  def display_image
    return 'bio' if only_biology?
    return 'math' if only_math?
    return 'phy' if only_physics?
    return 'chem' if only_chemistry?
    return 'neet' if neet?
    return 'jee' if jee?

    'general'
  end

  private

  def check_exam(section)
    sections.pluck(:name) == [section]
  end

  def only_biology?
    check_exam('biology')
  end

  def only_math?
    check_exam('maths')
  end

  def only_physics?
    check_exam('physics')
  end

  def only_chemistry?
    check_exam('chemistry')
  end

  def only_general?
    check_exam('general')
  end

  def jee?
    sections.pluck(:name).length > 1 && sections.pluck(:name).include?('maths')
  end

  def neet?
    sections.pluck(:name).length > 1 && sections.pluck(:name).include?('biology')
  end

  def send_push_notifications
    fcm = FCM.new(FCM_SERVER_KEY)
    batches.each do |batch|
      reg_ids = batch.students.where.not(fcm_token: nil).pluck(:fcm_token)
      # response = fcm.send(reg_ids, push_options)
      fcm.send(reg_ids, push_options)
    end
  end

  def push_options
    {
      priority: 'high',
      data: {
        message: "New Exam Added"
      },
      notification: {
        body: 'Please appear for the exam added, Exam will be available for 24 Hrs in new exams section.',
        title: "New Exam Added - '#{self.name}'",
        image: 'https://smart-exams-production.s3.ap-south-1.amazonaws.com/apks/dhote-logo.png'
      }
    }
  end
end
