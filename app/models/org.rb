# == Schema Information
#
# Table name: orgs
#
#  id                 :bigint(8)        not null, primary key
#  about_us_link      :string
#  data               :jsonb
#  fcm_server_key     :string
#  name               :string
#  subdomain          :string
#  vimeo_access_token :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_orgs_on_subdomain  (subdomain)
#

class Org < ApplicationRecord
  def bhargav?
    subdomain == 'bhargav'
  end
end
