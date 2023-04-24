class AddIndexOnRollNumber < ActiveRecord::Migration[5.2]
  def change
    add_index :students, :roll_number
  end
end
