class ChangeTableNewAdmission < ActiveRecord::Migration[5.2]
  def change
    add_column :new_admissions, :name, :string
    add_column :new_admissions, :batch, :integer, default: 0
  end
end
