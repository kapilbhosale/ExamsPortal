class CreateExams < ActiveRecord::Migration[5.2]
  def change
    create_table :exams do |t|
      t.string    :name, null: false
      t.text      :description
      t.integer   :no_of_questions
      t.integer   :time_in_minutes
      t.boolean   :published
      t.timestamps
    end

    add_index :exams, :name
  end
end
