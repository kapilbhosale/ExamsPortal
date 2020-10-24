class RenameSubjectToSubjectNameToVideos < ActiveRecord::Migration[5.2]
  def change
    rename_column :video_lectures, :subject, :subject_name
  end
end
