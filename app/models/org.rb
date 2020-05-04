# == Schema Information
#
# Table name: orgs
#
#  id                 :bigint(8)        not null, primary key
#  about_us_link      :string
#  data               :jsonb
#  fcm_server_key     :string
#  subdomain          :string
#  vimeo_access_token :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Org < ApplicationRecord
end
