# == Schema Information
#
# Table name: report_print_statuses
#
#  id          :bigint(8)        not null, primary key
#  report_type :string
#  status      :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  admin_id    :bigint(8)
#  branch_id   :integer          default(1), not null
#
# Indexes
#
#  index_report_print_statuses_on_admin_id   (admin_id)
#  index_report_print_statuses_on_branch_id  (branch_id)
#
# Foreign Keys
#
#  fk_rails_...  (admin_id => admins.id)
#

require 'test_helper'

class ReportPrintStatusTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
