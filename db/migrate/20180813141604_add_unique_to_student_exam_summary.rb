class AddUniqueToStudentExamSummary < ActiveRecord::Migration[5.2]
  def change
    remove_index :student_exam_summaries, :student_exam_id
    add_index :student_exam_summaries, [:student_exam_id, :section_id], unique: true
  end
end
