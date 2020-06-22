class AddColumnNewAdmissionIdToStudents < ActiveRecord::Migration[5.2]
  def change
    add_column :students, :new_admission_id, :integer, default: nil
  end
end
