class AddColumnTotalScoreToStudentExamSummary < ActiveRecord::Migration[5.2]
  def change
    add_column :student_exam_summaries, :total_score, :integer, default: 0
  end
end
