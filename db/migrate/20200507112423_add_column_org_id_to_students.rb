class AddColumnOrgIdToStudents < ActiveRecord::Migration[5.2]
  def change
    add_column :students, :org_id, :integer, default: 0
  end
end
