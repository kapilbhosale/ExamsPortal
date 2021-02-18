class AddColumnOrgIdToRawAttendance < ActiveRecord::Migration[5.2]
  def change
    add_column :raw_attendances, :org_id, :integer
  end
end
