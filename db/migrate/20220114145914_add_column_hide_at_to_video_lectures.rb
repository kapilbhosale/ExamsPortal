class AddColumnHideAtToVideoLectures < ActiveRecord::Migration[5.2]
  def change
    add_column :video_lectures, :hide_at, :datetime
  end
end
