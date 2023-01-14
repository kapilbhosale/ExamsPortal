class AddColumnDataToStudents < ActiveRecord::Migration[5.2]
  def change
    add_column :students, :data, :jsonb, default: {}
  end
end
