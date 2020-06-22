class AddColumnLaptpVimeoIdToVideoLectures < ActiveRecord::Migration[5.2]
  def change
    add_column :video_lectures, :laptop_vimeo_id, :integer
  end
end
