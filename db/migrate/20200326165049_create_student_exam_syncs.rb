class CreateStudentExamSyncs < ActiveRecord::Migration[5.2]
  def change
    create_table :student_exam_syncs do |t|
      t.references :student
      t.references :exam
      t.jsonb :sync_data, default: {}
      t.timestamps
    end
  end
end
