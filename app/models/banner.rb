# == Schema Information
#
# Table name: banners
#
#  id           :bigint(8)        not null, primary key
#  image        :string
#  on_click_url :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  org_id       :bigint(8)
#
# Indexes
#
#  index_banners_on_org_id  (org_id)
#

class Banner < ApplicationRecord
end
