# == Schema Information
#
# Table name: exams
#
#  id              :bigint(8)        not null, primary key
#  description     :text
#  name            :string           not null
#  no_of_questions :integer
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

  # has_one :style, as: :component, dependent: :destroy
end
