class CreateOmrBatchTests < ActiveRecord::Migration[5.2]
  def change
    create_table :omr_batch_tests do |t|
      t.references :omr_batch, foreign_key: true
      t.references :omr_test, foreign_key: true
      t.timestamps
    end
  end
end
