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

require 'test_helper'

class Omr::StudentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
