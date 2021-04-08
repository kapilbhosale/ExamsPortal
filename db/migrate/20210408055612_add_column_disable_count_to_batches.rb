class AddColumnDisableCountToBatches < ActiveRecord::Migration[5.2]
  def change
    add_column :batches, :disable_count, :integer, default: 0
  end
end
