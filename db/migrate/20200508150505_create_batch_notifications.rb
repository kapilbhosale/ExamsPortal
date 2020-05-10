class CreateBatchNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :batch_notifications do |t|
      t.references :notification
      t.references :batch
      t.timestamps
    end
  end
end
