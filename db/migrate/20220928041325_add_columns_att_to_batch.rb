class AddColumnsAttToBatch < ActiveRecord::Migration[5.2]
  def change
    add_column :batches, :start_time, :timestamp
    add_column :batches, :end_time, :timestamp
    add_column :batches, :config, :jsonb
  end
end
