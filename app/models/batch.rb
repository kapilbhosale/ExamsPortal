# == Schema Information
#
# Table name: batches
#
#  id         :bigint(8)        not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  org_id     :integer          default(0)
#

class Batch < ApplicationRecord
  has_many  :student_batches, dependent: :destroy
  has_many  :students, through: :student_batches, dependent: :destroy

  has_many :exams_batches
  has_many :exams, through: :exams_batches
  validates :name, presence: true

  has_many :batch_video_lectures
  has_many :video_lectures, through: :batch_video_lectures

  has_many :batch_study_pdfs
  has_many :study_pdfs, through: :batch_study_pdfs

  belongs_to :org

  def self.all_batches
    Batch.all{|batch| [batch.id, batch.name]}
  end
end
