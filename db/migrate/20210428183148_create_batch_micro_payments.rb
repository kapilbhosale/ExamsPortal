class CreateBatchMicroPayments < ActiveRecord::Migration[5.2]
  def change
    create_table :batch_micro_payments do |t|
      t.references :micro_payment
      t.references :batch
      t.timestamps
    end
  end
end
