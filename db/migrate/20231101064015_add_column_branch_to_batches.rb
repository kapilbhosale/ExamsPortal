class AddColumnBranchToBatches < ActiveRecord::Migration[5.2]
  def change
    add_column :batches, :branch, :string, default: 'home'
  end
end
