class AddColumnEnabledToVideoLecture < ActiveRecord::Migration[5.2]
  def change
    add_column :video_lectures, :enabled, :boolean, default: true
  end
end
