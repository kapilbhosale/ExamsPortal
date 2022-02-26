class AddColumnExamHallToStudents < ActiveRecord::Migration[5.2]
  def change
    add_column :students, :exam_hall, :string
  end
end
