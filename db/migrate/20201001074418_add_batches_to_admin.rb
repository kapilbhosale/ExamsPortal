class AddBatchesToAdmin < ActiveRecord::Migration[5.2]
  def change
    Admin.all.each do |admin|
      admin.batches << Batch.where(org_id: admin.org_id)
    end
  end
end
