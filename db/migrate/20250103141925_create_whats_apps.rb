class CreateWhatsApps < ActiveRecord::Migration[5.2]
  def change
    create_table :whats_apps do |t|
      t.string :phone_number
      t.string :message
      t.string :var_1
      t.string :var_2
      t.string :var_3
      t.string :var_4
      t.timestamps
    end
  end
end
