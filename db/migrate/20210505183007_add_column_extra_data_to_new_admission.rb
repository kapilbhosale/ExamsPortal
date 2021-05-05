class AddColumnExtraDataToNewAdmission < ActiveRecord::Migration[5.2]
  def change
    add_column :new_admissions, :extra_data, :jsonb, default: {}
  end
end
