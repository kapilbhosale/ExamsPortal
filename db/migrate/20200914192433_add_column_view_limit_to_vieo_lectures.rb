class AddColumnViewLimitToVieoLectures < ActiveRecord::Migration[5.2]
  def change
    add_column :video_lectures, :view_limit, :integer, default: 3
  end
end
