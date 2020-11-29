# == Schema Information
#
# Table name: batch_groups
#
#  id         :bigint(8)        not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  org_id     :bigint(8)
#
# Indexes
#
#  index_batch_groups_on_org_id  (org_id)
#

class BatchGroup < ApplicationRecord
  has_many :baches
  belongs_to :org
end
