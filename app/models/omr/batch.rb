# == Schema Information
#
# Table name: omr_batches
#
#  id               :bigint(8)        not null, primary key
#  branch           :string
#  db_modified_date :string
#  name             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  old_id           :integer
#  org_id           :bigint(8)
#
# Indexes
#
#  index_omr_batches_on_name_and_branch  (name,branch) UNIQUE
#  index_omr_batches_on_org_id           (org_id)
#
# Foreign Keys
#
#  fk_rails_...  (org_id => orgs.id)
#

class Omr::Batch < ApplicationRecord
  belongs_to :org
  has_many :omr_student_batches, class_name: 'Omr::StudentBatch', foreign_key: 'omr_batch_id'
  has_many :omr_students, through: :omr_student_batches

  has_many :omr_batch_tests, class_name: 'Omr::BatchTest', foreign_key: 'omr_batch_id'
  has_many :omr_tests, through: :omr_batch_tests
end
