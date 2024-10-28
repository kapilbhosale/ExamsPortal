class ModifyOmrStudentBatchesForeignKey < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :omr_student_batches, :omr_students
  end
end
