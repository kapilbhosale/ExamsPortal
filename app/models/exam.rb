# == Schema Information
#
# Table name: exams
#
#  id              :bigint(8)        not null, primary key
#  description     :text
#  name            :string           not null
#  negative_marks  :integer          default(1), not null
#  no_of_questions :integer
#  positive_marks  :integer          default(4), not null
#  publish_result  :boolean          default(FALSE), not null
#  published       :boolean
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
end
