class AddColumnTypeToAdmins < ActiveRecord::Migration[5.2]
  def change
    add_column :admins, :type, :string, default: 'Teacher'
  end
end
