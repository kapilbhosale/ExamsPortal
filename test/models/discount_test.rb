# == Schema Information
#
# Table name: discounts
#
#  id               :bigint(8)        not null, primary key
#  amount           :decimal(, )
#  approved_by      :string
#  comment          :string
#  data             :jsonb
#  parent_mobile    :string
#  roll_number      :string
#  status           :string
#  student_mobile   :string
#  student_name     :string
#  type_of_discount :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  org_id           :bigint(8)
#
# Indexes
#
#  index_discounts_on_org_id                         (org_id)
#  index_discounts_on_roll_number_and_parent_mobile  (roll_number,parent_mobile)
#

require 'test_helper'

class DiscountTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
