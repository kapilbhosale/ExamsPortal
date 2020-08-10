class AddColumnOrgIdToSubjects < ActiveRecord::Migration[5.2]
  def change
    add_column :subjects, :org_id, :integer
    add_index :subjects, :org_id
  end
end
