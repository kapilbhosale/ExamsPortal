class CreatePendingFees < ActiveRecord::Migration[5.2]
  def change
    create_table :pending_fees do |t|
      t.references :student
      t.decimal :amount
      t.boolean :paid, default: false
      t.integer :reference_no
      t.timestamps
    end
  end
end
