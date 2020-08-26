# == Schema Information
#
# Table name: zoom_meetings
#
#  id                  :bigint(8)        not null, primary key
#  datetime_of_meeting :datetime
#  live_type           :integer          default("zoom")
#  password            :string
#  subject             :string
#  teacher_name        :string
#  vimeo_live_show_url :string
#  vimeo_live_url      :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  org_id              :bigint(8)
#  zoom_meeting_id     :string
#
# Indexes
#
#  index_zoom_meetings_on_org_id  (org_id)
#

class ZoomMeeting < ApplicationRecord
  has_many :batch_zoom_meetings
  has_many :batches, through: :batch_zoom_meetings
  belongs_to :org

  before_save :sanitize_meeting_id

  enum live_type: {zoom: 0, vimeo: 1}

  def to_json
    {
      zoom_meeting_id: zoom_meeting_id,
      password: password,
      teacher: teacher_name,
      subject: subject,
      date: datetime_of_meeting.strftime("%d-%B-%Y"),
      time: datetime_of_meeting.strftime("%r"),
    }
  end

  private

  def sanitize_meeting_id
    self.zoom_meeting_id = zoom_meeting_id.squish.gsub(/\s/, "") if zoom_meeting_id.present?
  end
end
