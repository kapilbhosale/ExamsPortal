class CreateOmrStudents < ActiveRecord::Migration[5.2]
  def change
    create_table :omr_students do |t|
      t.references :org, foreign_key: true
      t.integer :student_id
      t.integer :roll_number
      t.string :parent_contact
      t.string :student_contact
      t.string :name
      t.string :branch
      t.timestamps
    end
  end
end
