class AddColumnOldIdToOmrModels < ActiveRecord::Migration[5.2]
  def change
    add_column :omr_students, :old_id, :integer
    add_column :omr_batches, :old_id, :integer
    add_column :omr_tests, :old_id, :integer
  end
end
