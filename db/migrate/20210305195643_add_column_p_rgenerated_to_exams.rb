class AddColumnPRgeneratedToExams < ActiveRecord::Migration[5.2]
  def change
    add_column :exams, :is_pr_generated, :boolean, default: false
  end
end
