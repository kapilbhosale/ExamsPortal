# == Schema Information
#
# Table name: att_machines
#
#  id         :bigint(8)        not null, primary key
#  disabled   :boolean          default(FALSE)
#  ip_address :string           not null
#  name       :string           not null
#  online     :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  org_id     :bigint(8)
#
# Indexes
#
#  index_att_machines_on_org_id  (org_id)
#

class AttMachine < ApplicationRecord
  validates_presence_of :name, :ip_address, :org_id

  belongs_to :org
end
