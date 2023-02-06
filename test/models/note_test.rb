# == Schema Information
#
# Table name: notes
#
#  id          :bigint(8)        not null, primary key
#  description :string
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  org_id      :bigint(8)
#
# Indexes
#
#  index_notes_on_org_id  (org_id)
#

require 'test_helper'

class NoteTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
