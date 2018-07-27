class CreateOptions < ActiveRecord::Migration[5.2]
  def change
    create_table :options do |t|
      t.references :question
      t.text :data
      t.boolean :is_answer
      t.timestamps
    end
  end
end
