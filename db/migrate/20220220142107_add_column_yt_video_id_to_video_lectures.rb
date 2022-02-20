class AddColumnYtVideoIdToVideoLectures < ActiveRecord::Migration[5.2]
  def change
    add_column :video_lectures, :yt_video_id, :string, default: nil
  end
end
