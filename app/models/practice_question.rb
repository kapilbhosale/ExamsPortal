# == Schema Information
#
# Table name: practice_questions
#
#  id          :bigint(8)        not null, primary key
#  hash        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  question_id :bigint(8)
#  topic_id    :bigint(8)
#
# Indexes
#
#  index_practice_questions_on_hash         (hash)
#  index_practice_questions_on_question_id  (question_id)
#  index_practice_questions_on_topic_id     (topic_id)
#

class PracticeQuestion < ApplicationRecord
  after_create :add_hash

  belongs_to :topic
  belongs_to :question

  validates_uniqueness_of :hash

  private
  def add_hash
    self.hash = question.get_hash_code
    self.save
  end
end
