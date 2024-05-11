class AddColumnDataToStudentTests < ActiveRecord::Migration[5.2]
  def change
    add_column :omr_student_tests, :data, :jsonb, default: {}
  end
end
