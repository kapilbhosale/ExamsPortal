class AddColumnShowResultAtToExams < ActiveRecord::Migration[5.2]
  def change
    add_column :exams, :show_result_at, :datetime
  end
end
