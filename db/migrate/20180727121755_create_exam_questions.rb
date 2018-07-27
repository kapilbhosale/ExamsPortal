class CreateExamQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :exam_questions do |t|
      t.references :exam
      t.references :question
      t.timestamps
    end
  end
end
