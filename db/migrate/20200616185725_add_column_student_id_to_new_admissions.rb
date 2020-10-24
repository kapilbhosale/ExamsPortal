class AddColumnStudentIdToNewAdmissions < ActiveRecord::Migration[5.2]
  def change
    add_column :new_admissions, :student_id, :integer
  end
end
