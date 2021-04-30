class CreateStudentPayments < ActiveRecord::Migration[5.2]
  def change
    create_table :student_payments do |t|
      t.references :student
      t.references :micro_payment
      t.string  :rz_order_id
      t.decimal :amount
      t.integer :status, default: 0
      t.jsonb   :raw_data, default: {}
      t.timestamps
    end
  end
end
