class AddColumnRazorPayOrderIdToNewAdmissions < ActiveRecord::Migration[5.2]
  def change
    add_column :new_admissions, :rz_order_id, :string
    add_column :new_admissions, :fees, :decimal, default: 0
  end
end
