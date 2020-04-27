class AddColumnVideoTypetoVideoLectures < ActiveRecord::Migration[5.2]
  def change
    add_column :video_lectures, :video_type, :integer, default: 0
  end
end
