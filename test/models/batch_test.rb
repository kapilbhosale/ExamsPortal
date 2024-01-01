# == Schema Information
#
# Table name: batches
#
#  id             :bigint(8)        not null, primary key
#  branch         :string           default("home")
#  config         :jsonb
#  device_ids     :string
#  disable_count  :integer          default(0)
#  edu_year       :string           default("2024-25")
#  end_time       :datetime
#  klass          :string
#  name           :string
#  start_time     :datetime
#  students_count :integer          default(0)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  batch_group_id :integer
#  org_id         :integer          default(0)
#
# Indexes
#
#  index_batches_on_batch_group_id  (batch_group_id)
#  index_batches_on_org_id          (org_id)
#

require 'test_helper'

class BatchTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
