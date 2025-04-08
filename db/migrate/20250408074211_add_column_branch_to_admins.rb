class AddColumnBranchToAdmins < ActiveRecord::Migration[5.2]
  def change
    add_column :admins, :branch_id, :integer, null: false, default: 1
    add_index :admins, :branch_id
  end
end
