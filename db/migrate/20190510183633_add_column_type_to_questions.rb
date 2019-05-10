class AddColumnTypeToQuestions < ActiveRecord::Migration[5.2]
  def change
    add_column :questions, :question_type, :integer, default: 0
  end
end
