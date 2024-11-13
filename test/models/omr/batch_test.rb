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

require 'test_helper'

class Omr::BatchTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
