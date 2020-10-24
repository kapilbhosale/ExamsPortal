class AddColumnQuestionPropsToStudentExamAnswers < ActiveRecord::Migration[5.2]
  def change
    add_column :student_exam_answers, :question_props, :jsonb, default: {}
  end
end
