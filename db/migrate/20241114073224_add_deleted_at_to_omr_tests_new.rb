class AddDeletedAtToOmrTestsNew < ActiveRecord::Migration[5.2]
  def change
    add_column :omr_tests, :deleted_at, :datetime
    add_index :omr_tests, :deleted_at
  end
end
