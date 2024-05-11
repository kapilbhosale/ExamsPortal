class CreateOmrStudentTests < ActiveRecord::Migration[5.2]
  def change
    create_table :omr_student_tests do |t|
      t.references  :omr_student
      t.references  :omr_test
      t.integer     :score, default: 0
      t.jsonb       :student_ans, default: []
      t.integer     :rank
      t.integer     :child_test_id
      t.timestamps
    end
  end
end
