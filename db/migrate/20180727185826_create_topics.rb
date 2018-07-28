class CreateTopics < ActiveRecord::Migration[5.2]
  def change
    create_table :topics do |t|
      t.references :section
      t.string :name, null: false
      t.string :name_map, null: false, index: true
      t.timestamps
    end
  end
end
