# == Schema Information
#
# Table name: sections
#
#  id          :bigint(8)        not null, primary key
#  description :text
#  is_jee      :boolean          default(FALSE)
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Section < ApplicationRecord
  has_many :exam_sections
  has_many :exams, through: :exam_sections

  has_many :questions

  scope :jee, ->() {where(is_jee: true)}
  scope :non_jee, ->() {where(is_jee: false)}

end
