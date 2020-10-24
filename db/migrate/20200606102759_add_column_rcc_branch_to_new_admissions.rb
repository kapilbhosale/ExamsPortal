class AddColumnRccBranchToNewAdmissions < ActiveRecord::Migration[5.2]
  def change
    add_column :new_admissions, :rcc_branch, :integer, default: 0
  end
end
