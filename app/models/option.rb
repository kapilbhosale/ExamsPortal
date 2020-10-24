# == Schema Information
#
# Table name: options
#
#  id          :bigint(8)        not null, primary key
#  data        :text
#  is_answer   :boolean
#  is_image    :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  question_id :bigint(8)
#
# Indexes
#
#  index_options_on_question_id  (question_id)
#

class Option < ApplicationRecord
  belongs_to :question
end
