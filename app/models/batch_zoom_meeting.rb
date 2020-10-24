# == Schema Information
#
# Table name: batch_zoom_meetings
#
#  id              :bigint(8)        not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  batch_id        :bigint(8)
#  zoom_meeting_id :bigint(8)
#
# Indexes
#
#  index_batch_zoom_meetings_on_batch_id         (batch_id)
#  index_batch_zoom_meetings_on_zoom_meeting_id  (zoom_meeting_id)
#

class BatchZoomMeeting < ApplicationRecord
  belongs_to :batch
  belongs_to :zoom_meeting
end
