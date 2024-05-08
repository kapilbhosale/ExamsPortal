class AddColumnIndexOnStudents < ActiveRecord::Migration[5.2]
  def change
    remove_index :students, name: 'index_students_on_roll_number_and_parent_mobile'
    add_index :students, [:roll_number, :parent_mobile], unique: true
  end
end
