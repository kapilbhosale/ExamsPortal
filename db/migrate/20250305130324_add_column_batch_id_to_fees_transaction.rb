class AddColumnBatchIdToFeesTransaction < ActiveRecord::Migration[5.2]
  def change
    add_reference :fees_transactions, :batch, foreign_key: true
  end
end
