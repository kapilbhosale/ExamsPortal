class AddColumnStatusToNewAdmission < ActiveRecord::Migration[5.2]
  def change
    add_column :new_admissions, :status, :string, default: 'default'
  end
end
