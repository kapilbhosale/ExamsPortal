# == Schema Information
#
# Table name: genres
#
#  id                   :bigint(8)        not null, primary key
#  batch_assigned       :boolean          default(FALSE)
#  hidden               :boolean          default(FALSE)
#  name                 :string
#  video_lectures_count :integer          default(0)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  org_id               :integer
#  subject_id           :integer
#
# Indexes
#
#  index_genres_on_org_id      (org_id)
#  index_genres_on_subject_id  (subject_id)
#

require 'test_helper'

class GenreTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
