class AddColumnFreeToNewAdmission < ActiveRecord::Migration[5.2]
  def change
    add_column :new_admissions, :free, :boolean, default: false
  end
end
