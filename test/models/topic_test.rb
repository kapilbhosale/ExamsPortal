# == Schema Information
#
# Table name: topics
#
#  id         :bigint(8)        not null, primary key
#  name       :string           not null
#  name_map   :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  concept_id :bigint(8)
#
# Indexes
#
#  index_topics_on_concept_id  (concept_id)
#  index_topics_on_name_map    (name_map)
#

require 'test_helper'

class TopicTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
