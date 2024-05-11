class CreateOmrBatchTests < ActiveRecord::Migration[5.2]
  def change
    create_table :omr_batch_tests do |t|
      t.references :omr_batch
      t.references :omr_test
      t.timestamps
    end
  end
end
