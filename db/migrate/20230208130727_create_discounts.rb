class CreateDiscounts < ActiveRecord::Migration[5.2]
  def change
    create_table :discounts do |t|
      t.references  :org
      t.string      :type_of_discount   #SET, LESS_FEES_REQ, NOTES_ISSUE_REQ
      t.decimal     :amount
      t.string      :comment
      t.string      :approved_by
      t.string      :status    #valid, used, expired

      t.string      :student_name
      t.string      :parent_mobile
      t.string      :student_mobile
      t.string      :roll_number
      t.jsonb       :data, default: {}

      t.timestamps
    end
  end
end
