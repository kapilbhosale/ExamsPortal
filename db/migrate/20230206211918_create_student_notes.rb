class CreateStudentNotes < ActiveRecord::Migration[5.2]
  def change
    create_table :student_notes do |t|
      t.references :org
      t.references :student
      t.references :note
      t.timestamps
    end
  end
end
