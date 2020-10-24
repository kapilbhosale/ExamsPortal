class AddColumnSubjectIdToVideoLecture < ActiveRecord::Migration[5.2]
  def change
    add_column :video_lectures, :subject_id, :integer
    add_index :video_lectures, :subject_id
  end
end
