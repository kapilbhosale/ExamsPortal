# == Schema Information
#
# Table name: questions
#
#  id               :bigint(8)        not null, primary key
#  difficulty_level :integer          default("default"), not null
#  explanation      :text
#  title            :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Question < ApplicationRecord
  has_many :exam_questions
  has_many :exams, through: :exam_questions
  has_many :options, dependent: :destroy
  has_one :style, as: :component, dependent: :destroy

  enum difficulty_level: {default: 0, easy: 1, medium: 2, difficult: 3, very_difficult: 4}

  def css_style
    ComponentStyle.where(component: self).first.style rescue ''
  end

  def get_hash_code
    Digest::MD5.hexdigest("#{question.title}.#{question.options.pluck(:data).join(',')}")
  end
end
