class CreatePhotoUploadLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :photo_upload_logs do |t|
      t.string  :filename
      t.integer :success_count
      t.integer :not_found_count
      t.jsonb   :sucess_roll_numbers
      t.jsonb   :not_found_roll_numbers
      t.string  :uploaded_by
      t.timestamps
    end
  end
end
