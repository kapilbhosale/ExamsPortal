class AddColumnIsLaptopLogin < ActiveRecord::Migration[5.2]
  def change
    add_column :students, :is_laptop_login, :boolean, default: false
    add_column :students, :access_type, :integer, default: 0
  end
end
