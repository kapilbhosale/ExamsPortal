class AddColumnVideosCountToGenres < ActiveRecord::Migration[5.2]
  def change
    add_column :genres, :video_lectures_count, :integer, default: 0
  end
end
