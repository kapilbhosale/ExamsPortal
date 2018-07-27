class CreateStudentExams < ActiveRecord::Migration[5.2]
  def change
    create_table :student_exams do |t|
    	t.references :student
    	t.references :exam
    	t.datetime   :started_at, null: false
    	t.datetime   :ended_at
      t.timestamps
    end
  end
end
