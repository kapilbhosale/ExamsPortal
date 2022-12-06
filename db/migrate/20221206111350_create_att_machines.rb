class CreateAttMachines < ActiveRecord::Migration[5.2]
  def change
    create_table :att_machines do |t|
      t.string  :name, null: false
      t.string  :ip_address, null: false
      t.boolean :disabled, default: false
      t.boolean :online, default: false
      t.references :org
      t.timestamps
    end
  end
end
