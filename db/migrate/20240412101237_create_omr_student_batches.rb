class CreateOmrStudentBatches < ActiveRecord::Migration[5.2]
  def change
    create_table :omr_student_batches do |t|
      t.references :omr_student, foreign_key: true
      t.references :omr_batch, foreign_key: true
      t.timestamps
    end
  end
end
