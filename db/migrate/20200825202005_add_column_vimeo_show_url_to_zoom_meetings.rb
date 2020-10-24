class AddColumnVimeoShowUrlToZoomMeetings < ActiveRecord::Migration[5.2]
  def change
    add_column :zoom_meetings, :vimeo_live_show_url, :string
  end
end
