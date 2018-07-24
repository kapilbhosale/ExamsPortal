class CreateStudentBatches < ActiveRecord::Migration[5.2]
  def change
    create_table :student_batches do |t|
      t.references :student
      t.references :batch

      t.timestamps
    end
  end
end
