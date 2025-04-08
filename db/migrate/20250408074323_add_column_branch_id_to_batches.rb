class AddColumnBranchIdToBatches < ActiveRecord::Migration[5.2]
  def change
    add_column :batches, :branch_id, :integer, null: false, default: 1
    add_index :batches, :branch_id
  end
end
