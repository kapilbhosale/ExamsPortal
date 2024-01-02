class AddDeletedAtToFeesTransactions < ActiveRecord::Migration[5.2]
  def change
    add_column :fees_transactions, :deleted_at, :datetime
    add_index :fees_transactions, :deleted_at
  end
end
