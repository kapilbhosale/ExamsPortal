# == Schema Information
#
# Table name: proxies
#
#  id          :bigint(8)        not null, primary key
#  conn_string :string
#  ip_and_port :string
#  password    :string
#  user_name   :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class ProxyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
