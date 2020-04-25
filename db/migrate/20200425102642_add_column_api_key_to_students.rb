class AddColumnApiKeyToStudents < ActiveRecord::Migration[5.2]
  def change
    add_column :students, :api_key, :string
    add_column :students, :fcm_id, :string
  end
end
