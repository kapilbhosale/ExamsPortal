class AddUniqueIndexOnOmrBatches < ActiveRecord::Migration[5.2]
  def change
    # add_index :omr_batches, [:name, :branch], unique: true, name: 'index_omr_batches_on_name_and_branch'
  end
end
