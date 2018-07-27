class CreateAnswerOptions < ActiveRecord::Migration[5.2]
  def change
    create_table :answer_options do |t|
      t.references :question
      t.text :option
      t.boolean :is_answer
      t.timestamps
    end
  end
end
