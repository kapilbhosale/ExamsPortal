class CreateVideoLectures < ActiveRecord::Migration[5.2]
  def change
    create_table :video_lectures do |t|
      t.string :title
      t.string :url
      t.string :video_id
      t.string :description
      t.string :thumbnail
      t.string :by
      t.string :tag
      t.integer :subject
      t.timestamps
    end
  end
end