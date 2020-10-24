class AddColumnLiveTypeToZoomMeetings < ActiveRecord::Migration[5.2]
  def change
    add_column :zoom_meetings, :live_type, :integer, default: 0
    add_column :zoom_meetings, :vimeo_live_url, :string
  end
end
