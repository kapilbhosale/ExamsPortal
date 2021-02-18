class CreateRawAttendances < ActiveRecord::Migration[5.2]
  def change
    create_table :raw_attendances do |t|
      t.jsonb   :data, default: {}
      t.boolean :processed, default: false
      t.timestamps
    end
  end
end
