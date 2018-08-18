class AddUniquesnessValidationToStudentBatch < ActiveRecord::Migration[5.2]
  def change
    add_index :student_batches, [:student_id, :batch_id], unique: true
  end
end

# script to delete existing duplicates
# StudentBatch.select(:student_id, :batch_id).group(:student_id, :batch_id).having("count(*) > 1").map do |x|
#   StudentBatch.where(batch_id: x.batch_id, student_id: x.student_id).last.destroy
# end
