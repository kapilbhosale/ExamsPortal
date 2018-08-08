# == Schema Information
#
# Table name: sections
#
#  id         :bigint(8)        not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Section < ApplicationRecord
  has_many :exam_sections
  has_many :exams, through: :exam_sections

  has_many :questions
end
