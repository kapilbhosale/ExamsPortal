class AddColumnBatchAssignedToGenres < ActiveRecord::Migration[5.2]
  def change
    add_column :genres, :batch_assigned, :boolean, default: false
  end
end
