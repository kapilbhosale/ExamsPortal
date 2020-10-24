class AddColumnPaymentCallbackDataToNewAdmissions < ActiveRecord::Migration[5.2]
  def change
    add_column :new_admissions, :payment_callback_data, :jsonb, default: {}
    add_column :new_admissions, :error_code, :string
    add_column :new_admissions, :error_info, :string
    add_column :new_admissions, :reference_id, :string
  end
end
