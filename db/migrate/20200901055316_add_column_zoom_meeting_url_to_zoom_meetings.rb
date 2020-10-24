class AddColumnZoomMeetingUrlToZoomMeetings < ActiveRecord::Migration[5.2]
  def change
    add_column :zoom_meetings, :zoom_meeting_url, :string
  end
end
