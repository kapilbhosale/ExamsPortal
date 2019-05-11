# == Schema Information
#
# Table name: sections
#
#  id          :bigint(8)        not null, primary key
#  description :text
#  is_jee      :boolean          default(FALSE)
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class SectionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
