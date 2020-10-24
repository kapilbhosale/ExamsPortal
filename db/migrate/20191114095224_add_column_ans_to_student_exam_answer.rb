class AddColumnAnsToStudentExamAnswer < ActiveRecord::Migration[5.2]
  def change
    add_column :student_exam_answers, :ans, :string
  end
end
