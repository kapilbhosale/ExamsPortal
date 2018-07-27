class CreateStudentQuestionAnswers < ActiveRecord::Migration[5.2]
  def change
    create_table :student_question_answers do |t|
      t.references :student
      t.references :question
      t.references :option
      t.timestamps
    end
  end
end
