class AddColumnBooketToOmrTests < ActiveRecord::Migration[5.2]
  def change
    add_column :omr_tests, :is_booklet, :boolean, default: false
    add_column :omr_tests, :is_combine, :boolean, default: false
  end
end
