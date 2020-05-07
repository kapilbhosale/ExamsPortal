class AddColumnOrgIdToBatche < ActiveRecord::Migration[5.2]
  def change
    add_column :batches, :org_id, :integer, default: 0
  end
end
