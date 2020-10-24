class AddColumnUploadedThumbnailToVideoLectures < ActiveRecord::Migration[5.2]
  def change
    add_column :video_lectures, :uploaded_thumbnail, :string
  end
end
