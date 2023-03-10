class AddColumnMinPayToNotes < ActiveRecord::Migration[5.2]
  def change
    add_column :notes, :min_pay, :string
  end
end
