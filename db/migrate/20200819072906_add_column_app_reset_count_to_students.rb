class AddColumnAppResetCountToStudents < ActiveRecord::Migration[5.2]
  def change
    add_column :students, :app_reset_count, :integer, default: 0
  end
end
