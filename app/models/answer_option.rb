# == Schema Information
#
# Table name: answer_options
#
#  id          :bigint(8)        not null, primary key
#  is_answer   :boolean
#  option      :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  question_id :bigint(8)
#
# Indexes
#
#  index_answer_options_on_question_id  (question_id)
#

class AnswerOption < ApplicationRecord
end
