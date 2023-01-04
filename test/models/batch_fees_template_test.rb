# == Schema Information
#
# Table name: batch_fees_templates
#
#  id               :bigint(8)        not null, primary key
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  batch_id         :bigint(8)
#  fees_template_id :bigint(8)
#
# Indexes
#
#  batch_fees_template_index                       (fees_template_id,batch_id) UNIQUE
#  index_batch_fees_templates_on_batch_id          (batch_id)
#  index_batch_fees_templates_on_fees_template_id  (fees_template_id)
#

require 'test_helper'

class BatchFeesTemplateTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
