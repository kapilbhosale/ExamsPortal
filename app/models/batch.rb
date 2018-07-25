# == Schema Information
#
# Table name: batches
#
#  id         :bigint(8)        not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Batch < ApplicationRecord
  has_many  :student_batches
  has_many  :students, through: :student_batches

  validates :name, presence: true

  def self.all_batches
    Batch.all{|batch| [batch.id, batch.name]}
  end
end
