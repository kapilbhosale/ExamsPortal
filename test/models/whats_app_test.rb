# == Schema Information
#
# Table name: whats_apps
#
#  id           :bigint(8)        not null, primary key
#  message      :string
#  phone_number :string
#  var_1        :string
#  var_2        :string
#  var_3        :string
#  var_4        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'test_helper'

class WhatsAppTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
