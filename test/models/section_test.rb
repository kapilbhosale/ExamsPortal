# == Schema Information
#
# Table name: sections
#
#  id         :bigint(8)        not null, primary key
#  name       :string           not null
#  name_map   :string           not null
#  weightage  :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  subject_id :bigint(8)
#
# Indexes
#
#  index_sections_on_name_map    (name_map)
#  index_sections_on_subject_id  (subject_id)
#

require 'test_helper'

class SectionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
