class CreatePracticeQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :practice_questions do |t|
      t.references  :topic
      t.references  :question
      t.string      :hash
      t.timestamps
    end
    add_index :practice_questions, :hash
  end
end
