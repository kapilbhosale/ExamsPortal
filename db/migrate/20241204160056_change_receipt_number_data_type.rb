class ChangeReceiptNumberDataType < ActiveRecord::Migration[5.2]
  def change
    # change fees_transactions tables, column receipt_number to string
    change_column :fees_transactions, :receipt_number, :string
  end
end
