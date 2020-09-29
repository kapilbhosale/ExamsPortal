class CreateAdminBatches < ActiveRecord::Migration[5.2]
  def change
    create_table :admin_batches do |t|
      t.references :admin
      t.references :batch
      t.timestamps
    end
  end
end
