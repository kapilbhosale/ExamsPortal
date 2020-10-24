class CreateBatchVideoLectures < ActiveRecord::Migration[5.2]
  def change
    create_table :batch_video_lectures do |t|
      t.references :video_lecture
      t.references :batch
      t.timestamps
    end
    add_index :batch_video_lectures, [:video_lecture_id, :batch_id], unique: true, name: :batch_vl_index
  end
end
