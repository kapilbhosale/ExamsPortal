class AddColumnRfidCardNumberToStudents < ActiveRecord::Migration[5.2]
  def change
    add_column :students, :rfid_card_number, :string
  end
end
