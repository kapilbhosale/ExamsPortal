class AddNullValidationOnBatchIdOnFeesTransaction < ActiveRecord::Migration[5.2]
  def change
    first_batch_id = execute("SELECT id FROM batches LIMIT 1").first['id']
    execute "UPDATE fees_transactions SET batch_id = #{first_batch_id} WHERE batch_id IS NULL"
    change_column :fees_transactions, :batch_id, :integer, null: false
  end
end
