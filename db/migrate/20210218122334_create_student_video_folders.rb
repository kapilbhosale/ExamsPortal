class CreateStudentVideoFolders < ActiveRecord::Migration[5.2]
  def change
    create_table :student_video_folders do |t|
      t.references  :student, null: false
      t.references  :genre, null: false
      t.timestamp   :show_till_date, null: false
      t.timestamps
    end
  end
end
