class AddColumnDisableToStudents < ActiveRecord::Migration[5.2]
  def change
    add_column :students, :disable, :boolean, default: false
  end
end
