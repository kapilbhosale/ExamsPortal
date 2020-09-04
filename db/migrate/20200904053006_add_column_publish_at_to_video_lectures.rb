class AddColumnPublishAtToVideoLectures < ActiveRecord::Migration[5.2]
  def change
    add_column :video_lectures, :publish_at, :datetime
  end
end
