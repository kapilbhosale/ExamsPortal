class AddColumnOrgIdToExams < ActiveRecord::Migration[5.2]
  def change
    add_column :exams, :org_id, :integer, default: 0
  end
end
