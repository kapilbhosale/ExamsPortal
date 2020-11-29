class AddColumnBatchGroupIdToBatch < ActiveRecord::Migration[5.2]
  def change
    add_column :batches, :batch_group_id, :integer
  end
end
