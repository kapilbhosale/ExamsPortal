class CreateStudentExamAnswers < ActiveRecord::Migration[5.2]
  def change
    create_table :student_exam_answers do |t|
    	t.references :student_exam
    	t.references :question
    	t.references :option
      t.timestamps
    end
  end
end
