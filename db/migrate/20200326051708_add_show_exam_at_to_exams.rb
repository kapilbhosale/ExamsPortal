class AddShowExamAtToExams < ActiveRecord::Migration[5.2]
  def change
    add_column :exams, :show_exam_at, :datetime
  end
end
