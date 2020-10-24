class AddColumnExamAvailableTillToExams < ActiveRecord::Migration[5.2]
  def change
    add_column :exams, :exam_available_till, :datetime
  end
end
