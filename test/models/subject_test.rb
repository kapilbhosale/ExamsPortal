# == Schema Information
#
# Table name: subjects
#
#  id         :bigint(8)        not null, primary key
#  klass      :string
#  name       :string           not null
#  name_map   :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  org_id     :integer
#
# Indexes
#
#  index_subjects_on_name_map  (name_map)
#  index_subjects_on_org_id    (org_id)
#

require 'test_helper'

class SubjectTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
