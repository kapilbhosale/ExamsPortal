class AddGenreIdToVideoLecture < ActiveRecord::Migration[5.2]
  def change
    add_column :video_lectures, :genre_id, :integer, presence: true, default: 0
  end
end
