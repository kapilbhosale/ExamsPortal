# == Schema Information
#
# Table name: student_video_folders
#
#  id             :bigint(8)        not null, primary key
#  show_till_date :datetime         not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  genre_id       :bigint(8)        not null
#  student_id     :bigint(8)        not null
#
# Indexes
#
#  index_student_video_folders_on_genre_id    (genre_id)
#  index_student_video_folders_on_student_id  (student_id)
#

class StudentVideoFolder < ApplicationRecord
  belongs_to :student
  belongs_to :genre

  validates :genre_id, uniqueness: { scope: :student_id }
end
