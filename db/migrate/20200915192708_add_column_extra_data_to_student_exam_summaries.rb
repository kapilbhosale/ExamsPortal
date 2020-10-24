class AddColumnExtraDataToStudentExamSummaries < ActiveRecord::Migration[5.2]
  def change
    add_column :student_exam_summaries, :extra_data, :jsonb, default: {}
  end
end
