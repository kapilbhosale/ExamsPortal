class AddColumnRolesToAdmin < ActiveRecord::Migration[5.2]
  def change
    add_column :admins, :roles, :jsonb, default: []
  end
end
