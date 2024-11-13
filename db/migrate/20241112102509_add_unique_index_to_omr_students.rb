class AddUniqueIndexToOmrStudents < ActiveRecord::Migration[5.2]
  def change
    add_index :omr_students, [:roll_number, :parent_contact], unique: true, name: 'index_omr_students_on_roll_number_and_parent_contact'
  end
end
