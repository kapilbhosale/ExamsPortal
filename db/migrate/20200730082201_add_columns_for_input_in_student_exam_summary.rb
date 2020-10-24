class AddColumnsForInputInStudentExamSummary < ActiveRecord::Migration[5.2]
  def change
    add_column :student_exam_summaries, :input_questions_present, :boolean, default: false
    add_column :student_exam_summaries, :correct_input_questions, :integer, default: 0
    add_column :student_exam_summaries, :incorrect_input_questions, :integer, default: 0
  end
end
