# == Schema Information
#
# Table name: questions
#
#  id               :bigint(8)        not null, primary key
#  difficulty_level :integer          default("default"), not null
#  explanation      :text
#  is_image         :boolean          default(FALSE)
#  question_type    :integer          default("single_select")
#  title            :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  section_id       :integer          default(1)
#

class Question < ApplicationRecord
  has_many :exam_questions
  has_many :exams, through: :exam_questions
  has_many :options, dependent: :destroy
  belongs_to :section

  enum question_type: { single_select: 0, multi_select: 1, input: 2 }
  enum difficulty_level: {default: 0, easy: 1, medium: 2, difficult: 3, very_difficult: 4}

  def css_style
    ComponentStyle.where(component: self).first.style rescue ''
  end

  def get_hash_code
    Digest::MD5.hexdigest("#{question.title}.#{question.options.pluck(:data).join(',')}")
  end

  # Assuming now, that there will be single correct ans
  def correct_option_id
    options.where(is_answer: true).first.id
  end

  def correct_ans
    options.where(is_answer: true).ids.join(',')
  end
end
