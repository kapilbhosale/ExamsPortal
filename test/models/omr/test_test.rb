# == Schema Information
#
# Table name: omr_tests
#
#  id               :bigint(8)        not null, primary key
#  answer_key       :jsonb
#  branch           :string
#  data             :jsonb
#  db_modified_date :string
#  description      :string
#  is_booklet       :boolean          default(FALSE)
#  is_combine       :boolean          default(FALSE)
#  no_of_questions  :integer          default(0)
#  test_date        :datetime
#  test_name        :string           not null
#  toppers          :jsonb
#  total_marks      :integer          default(0)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  old_id           :integer
#  org_id           :bigint(8)
#  parent_id        :integer
#
# Indexes
#
#  index_omr_tests_on_org_id  (org_id)
#
# Foreign Keys
#
#  fk_rails_...  (org_id => orgs.id)
#

require 'test_helper'

class Omr::TestTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
