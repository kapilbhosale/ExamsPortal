# == Schema Information
#
# Table name: topics
#
#  id         :bigint(8)        not null, primary key
#  name       :string           not null
#  name_map   :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  section_id :bigint(8)
#
# Indexes
#
#  index_topics_on_name_map    (name_map)
#  index_topics_on_section_id  (section_id)
#

require 'test_helper'

class TopicTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
