class AddColumnPrevReceiptNoToNewAdmissions < ActiveRecord::Migration[5.2]
  def change
    add_column :new_admissions, :prev_receipt_number, :text
  end
end
