class AddDeletedAtToIndexOnOmrStudents < ActiveRecord::Migration[5.2]
  def change
    remove_index :omr_students, [:roll_number, :parent_contact]
    add_index :omr_students, [:roll_number, :parent_contact, :deleted_at], unique: true, name: 'index_omr_students_unique'
  end
end
