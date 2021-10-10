class AddColumnToVideoLectures < ActiveRecord::Migration[5.2]
  def change
    add_column :video_lectures, :play_url_from_server, :string
    add_column :video_lectures, :link_udpated_at, :datetime
  end
end
