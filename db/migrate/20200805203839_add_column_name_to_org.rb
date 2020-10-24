class AddColumnNameToOrg < ActiveRecord::Migration[5.2]
  def change
    add_column :orgs, :name, :string
  end
end
