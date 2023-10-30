# == Schema Information
#
# Table name: batch_holidays
#
#  id           :bigint(8)        not null, primary key
#  comment      :string
#  holiday_date :date
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  batch_id     :bigint(8)
#  org_id       :bigint(8)
#
# Indexes
#
#  index_batch_holidays_on_batch_id  (batch_id)
#  index_batch_holidays_on_org_id    (org_id)
#

require 'test_helper'

class BatchHolidayTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
