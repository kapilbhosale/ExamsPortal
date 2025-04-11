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


  def delete_branch_data(branch)
    puts "==== deleting batch data for branch: #{branch} ===="
    Omr::Batch.where(branch: branch).each do |batch|
      Omr::BatchTest.where(omr_batch_id: batch.id).delete_all
      Omr::StudentBatch.where(omr_batch_id: batch.id).delete_all
      batch.delete
      putc"."
    end

    puts "==== deleting test data for branch: #{branch} ===="
    Omr::Test.where(branch: branch).each do |test|
      Omr::StudentTest.where(omr_test_id: test.id).delete_all
      test.delete
      putc"."
    end

    puts "==== deleting students for branch: #{branch} ===="
    Omr::Student.where(branch: branch).delete_all
  end

  def self.delete_all_data
    # Use transaction to ensure all operations succeed or fail together
    ActiveRecord::Base.transaction do
      query = <<-SQL
        TRUNCATE TABLE
          omr_batch_tests,
          omr_student_tests,
          omr_student_batches,
          omr_batches,
          omr_students,
          omr_tests
        RESTART IDENTITY CASCADE
      SQL

    ActiveRecord::Base.connection.execute(query)
    end
  end
end











