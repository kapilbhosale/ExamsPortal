class AddColumnIsHeadlessToFeesTransactions < ActiveRecord::Migration[5.2]
  def change
    add_column :fees_transactions, :is_headless, :boolean, default: false
  end
end
