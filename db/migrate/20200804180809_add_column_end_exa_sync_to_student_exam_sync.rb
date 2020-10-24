class AddColumnEndExaSyncToStudentExamSync < ActiveRecord::Migration[5.2]
  def change
    add_column :student_exam_syncs, :end_exam_sync, :boolean, default: false
  end
end
