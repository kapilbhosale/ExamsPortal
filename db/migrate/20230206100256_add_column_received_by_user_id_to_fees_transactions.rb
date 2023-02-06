class AddColumnReceivedByUserIdToFeesTransactions < ActiveRecord::Migration[5.2]
  def change
    add_column :fees_transactions, :received_by_admin_id, :integer
  end
end
