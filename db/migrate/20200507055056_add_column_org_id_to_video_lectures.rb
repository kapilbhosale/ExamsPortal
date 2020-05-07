class AddColumnOrgIdToVideoLectures < ActiveRecord::Migration[5.2]
  def change
    add_column :video_lectures, :org_id, :integer, default: 0
  end
end
