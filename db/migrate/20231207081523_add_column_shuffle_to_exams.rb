class AddColumnShuffleToExams < ActiveRecord::Migration[5.2]
  def change
    add_column :exams, :shuffle_questions, :boolean, default: false, null: false
  end
end
