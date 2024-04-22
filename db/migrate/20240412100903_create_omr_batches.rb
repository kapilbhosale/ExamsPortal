class CreateOmrBatches < ActiveRecord::Migration[5.2]
  def change
    create_table :omr_batches do |t|
      t.references  :org, foreign_key: true
      t.string      :name
      t.string      :db_modified_date
      t.string      :branch
      t.timestamps
    end
  end
end
