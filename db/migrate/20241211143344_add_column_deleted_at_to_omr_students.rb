class AddColumnDeletedAtToOmrStudents < ActiveRecord::Migration[5.2]
  def change
    add_column :omr_students, :deleted_at, :datetime
    add_index :omr_students, :deleted_at
  end
end
