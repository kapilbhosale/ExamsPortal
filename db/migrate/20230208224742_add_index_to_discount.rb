class AddIndexToDiscount < ActiveRecord::Migration[5.2]
  def change
    add_index :discounts, [:roll_number, :parent_mobile]
  end
end
