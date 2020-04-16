# == Schema Information
#
# Table name: batch_video_lectures
#
#  id               :bigint(8)        not null, primary key
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  batch_id         :bigint(8)
#  video_lecture_id :bigint(8)
#
# Indexes
#
#  batch_vl_index                                  (video_lecture_id,batch_id) UNIQUE
#  index_batch_video_lectures_on_batch_id          (batch_id)
#  index_batch_video_lectures_on_video_lecture_id  (video_lecture_id)
#

class BatchVideoLecture < ApplicationRecord
  belongs_to :batch
  belongs_to :video_lecture
end
