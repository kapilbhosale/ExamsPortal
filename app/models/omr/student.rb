# == Schema Information
#
# Table name: omr_students
#
#  id              :bigint(8)        not null, primary key
#  branch          :string
#  deleted_at      :datetime
#  name            :string
#  parent_contact  :string
#  roll_number     :integer
#  student_contact :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  old_id          :integer
#  org_id          :bigint(8)
#  student_id      :integer
#
# Indexes
#
#  index_omr_students_on_deleted_at  (deleted_at)
#  index_omr_students_on_org_id      (org_id)
#  index_omr_students_unique         (roll_number,parent_contact,deleted_at) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (org_id => orgs.id)
#

class Omr::Student < ApplicationRecord
  acts_as_paranoid

  belongs_to :student, optional: true
  belongs_to :org

  has_many :omr_student_batches, class_name: 'Omr::StudentBatch', foreign_key: 'omr_student_id'
  has_many :omr_batches, through: :omr_student_batches

  has_many :omr_student_tests, class_name: 'Omr::StudentTest', foreign_key: 'omr_student_id'
  has_many :omr_tests, through: :omr_student_tests

end

# Omr::BatchTest.delete_all
# ActiveRecord::Base.connection.reset_pk_sequence!('student_batches')

# Omr::StudentBatch.delete_all
# ActiveRecord::Base.connection.reset_pk_sequence!('omr_student_batches')

# Omr::StudentTest.delete_all
# ActiveRecord::Base.connection.reset_pk_sequence!('omr_student_tests')

# Omr::Batch.delete_all
# ActiveRecord::Base.connection.reset_pk_sequence!('omr_batches')

# Omr::Student.delete_all
# ActiveRecord::Base.connection.reset_pk_sequence!('omr_students')

# Omr::Test.delete_all
# ActiveRecord::Base.connection.reset_pk_sequence!('omr_tests')

