class AddColumnBranchIdToReportPrintStatus < ActiveRecord::Migration[5.2]
  def change
    remove_column :report_print_statuses, :branch
    add_column :report_print_statuses, :branch_id, :integer, null: false, default: 1
    add_index :report_print_statuses, :branch_id
  end
end
