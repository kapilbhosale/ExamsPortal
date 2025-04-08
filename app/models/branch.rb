# == Schema Information
#
# Table name: branches
#
#  id         :bigint(8)        not null, primary key
#  address    :string
#  code       :string           not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  org_id     :bigint(8)
#
# Indexes
#
#  index_branches_on_org_id  (org_id)
#
# Foreign Keys
#
#  fk_rails_...  (org_id => orgs.id)
#

class Branch < ApplicationRecord
  belongs_to :org
  has_many :admins
end
