class AddColumnCommentToStudentNotes < ActiveRecord::Migration[5.2]
  def change
    add_column :student_notes, :comment, :text
  end
end
