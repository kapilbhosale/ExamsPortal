class AddColumnExamTypeToExams < ActiveRecord::Migration[5.2]
  def change
    add_column :exams, :exam_type, :integer, default: 0
  end
end
