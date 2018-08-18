class AddUniquesnessValidationToStudentBatch < ActiveRecord::Migration[5.2]
  def change
    add_index :student_batches, [:student_id, :batch_id], unique: true
  end
end
