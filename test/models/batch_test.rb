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

require 'test_helper'

class BatchTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
