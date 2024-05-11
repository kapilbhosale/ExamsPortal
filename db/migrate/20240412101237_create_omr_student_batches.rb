class CreateOmrStudentBatches < ActiveRecord::Migration[5.2]
  def change
    create_table :omr_student_batches do |t|
      t.references :omr_student
      t.references :omr_batch
      t.timestamps
    end
  end
end
