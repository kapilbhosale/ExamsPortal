class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :questions do |t|
      t.text :title
      t.text :explanation
      t.integer :difficulty_level, default: 0, null: false
      t.timestamps
    end
  end
end
