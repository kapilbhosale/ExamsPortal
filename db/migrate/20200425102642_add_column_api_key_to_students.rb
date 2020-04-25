class AddColumnApiKeyToStudents < ActiveRecord::Migration[5.2]
  def change
    add_column :students, :api_key, :string
    add_column :students, :fcm_token, :string
  end
end
