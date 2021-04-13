class AddColumnCourseTypeToNewAdmission < ActiveRecord::Migration[5.2]
  def change
    add_column :new_admissions, :course_type, :integer, default: 0
  end
end
