class AddColumnDeviceIdsToBatches < ActiveRecord::Migration[5.2]
  def change
    add_column :batches, :device_ids, :string
  end
end
