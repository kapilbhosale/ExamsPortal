class CreatePaymentTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :payment_transactions do |t|
      t.references  :student
      t.decimal     :amount
      t.string      :reference_number
      t.integer     :new_admission_id
      t.timestamps
    end
  end
end
