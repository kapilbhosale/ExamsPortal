class CreateAttendances < ActiveRecord::Migration[5.2]
  def change
    create_table :attendances do |t|
      t.references :org
      t.references :student
      t.timestamp  :time_entry
      t.integer    :time_stamp
      t.integer    :att_type, default: 0
      t.timestamps
    end
  end
end
