class AddIndexOnStudentExamAnswer < ActiveRecord::Migration[5.2]
  def change
    add_index :student_exam_answers, [:student_exam_id, :question_id], unique: true
  end
end
