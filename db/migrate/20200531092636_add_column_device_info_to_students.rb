class AddColumnDeviceInfoToStudents < ActiveRecord::Migration[5.2]
  def change
    add_column :students, :deviceUniqueId, :string
    add_column :students, :deviceName, :string
    add_column :students, :manufacturer, :string
    add_column :students, :brand, :string
  end
end
