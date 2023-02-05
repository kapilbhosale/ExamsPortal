# == Schema Information
#
# Table name: genres
#
#  id                   :bigint(8)        not null, primary key
#  batch_assigned       :boolean          default(FALSE)
#  hidden               :boolean          default(FALSE)
#  name                 :string
#  study_pdfs_count     :integer          default(0)
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

class Genre < ApplicationRecord
  has_many :video_lectures
  has_many :study_pdfs
  belongs_to :org
  belongs_to :subject, optional: true
end
# Genre.reset_counters(g.id, :video_lectures)
