class AddColumnSuggestedRollNumberToStudents < ActiveRecord::Migration[5.2]
  def change
    add_column :students, :suggested_roll_number, :integer
  end
end
