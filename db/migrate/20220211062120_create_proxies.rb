class CreateProxies < ActiveRecord::Migration[5.2]
  def change
    create_table :proxies do |t|
      t.string :user_name
      t.string :password
      t.string :ip_and_port
      t.string :conn_string
      t.timestamps
    end
  end
end
