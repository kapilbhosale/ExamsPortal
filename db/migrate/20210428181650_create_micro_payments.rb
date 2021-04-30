class CreateMicroPayments < ActiveRecord::Migration[5.2]
  def change
    create_table :micro_payments do |t|
      t.string  :link, null: false
      t.decimal :amount
      t.decimal :min_payable_amount
      t.references :org

      t.timestamps
    end
    add_index :micro_payments, :link, unique: true
  end
end
