class AddColumAppLoginToStudents < ActiveRecord::Migration[5.2]
  def change
    add_column :students, :app_login, :boolean, default: false
  end
end
