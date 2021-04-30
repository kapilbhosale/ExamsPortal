class AddColumnActiveToMicroPayments < ActiveRecord::Migration[5.2]
  def change
    add_column :micro_payments, :active, :boolean, default: true
  end
end
