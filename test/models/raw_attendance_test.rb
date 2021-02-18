# == Schema Information
#
# Table name: raw_attendances
#
#  id         :bigint(8)        not null, primary key
#  data       :jsonb
#  processed  :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  org_id     :integer
#

require 'test_helper'

class RawAttendanceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
