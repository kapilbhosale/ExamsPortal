class CreateFeesTransactions < ActiveRecord::Migration[5.2]
  def change
    enable_extension 'pgcrypto'

    create_table :fees_transactions, id: :uuid do |t|
      t.references  :org
      t.integer     :receipt_number, null: false
      t.references  :student
      t.string      :academic_year

      t.decimal     :paid_amount, default: 0
      t.decimal     :remaining_amount, default: 0
      t.decimal     :discount_amount, default: 0

      t.jsonb       :payment_details, default: {}
      t.date        :next_due_date

      t.string      :received_by
      t.string      :comment
      t.string      :mode
      t.timestamps

      t.integer     :token_of_the_day
    end
  end
end

