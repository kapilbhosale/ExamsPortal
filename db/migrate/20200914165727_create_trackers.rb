class CreateTrackers < ActiveRecord::Migration[5.2]
  def change
    create_table :trackers do |t|
      t.references :student
      t.string :resource_type
      t.integer :resource_id
      t.string :event
      t.jsonb :data, default: {}
      t.timestamps
    end
  end
end
