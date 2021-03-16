class AddColumnOrgIdToProgressReport < ActiveRecord::Migration[5.2]
  def change
    add_column :progress_reports, :org_id, :integer
  end
end
