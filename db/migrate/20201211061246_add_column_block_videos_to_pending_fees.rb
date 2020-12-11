class AddColumnBlockVideosToPendingFees < ActiveRecord::Migration[5.2]
  def change
    add_column :pending_fees, :block_videos, :boolean, default: false
  end
end
