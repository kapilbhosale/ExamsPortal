class AddColumnOrgIdToAdmin < ActiveRecord::Migration[5.2]
  def change
    add_column :admins, :org_id, :integer, default: 0
  end
end
