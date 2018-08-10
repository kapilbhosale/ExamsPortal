class CreateStudentExamSummary < ActiveRecord::Migration[5.2]
  def change
    create_table :student_exam_summaries do |t|
      t.references :student_exam
      t.references :section
      t.integer    :no_of_questions
      t.integer    :answered
      t.integer    :not_answered
      t.integer    :correct
      t.integer    :incorrect
      t.integer    :score
      t.timestamps
    end
  end
end
