class AddColumnPosetiveAndNegativeMarkstoExams < ActiveRecord::Migration[5.2]
  def change
    add_column :exams, :positive_marks, :integer, null: false, default: 4
    add_column :exams, :negative_marks, :integer, null: false, default: -1
  end
end
