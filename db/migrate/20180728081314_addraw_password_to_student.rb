class AddrawPasswordToStudent < ActiveRecord::Migration[5.2]
  def change
    add_column :students, :raw_password, :string
  end
end
