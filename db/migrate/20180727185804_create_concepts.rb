class CreateConcepts < ActiveRecord::Migration[5.2]
  def change
    create_table :concepts do |t|
        t.references :subject
        t.string :name, null: false
        t.string :name_map, null: false, index: true
        t.timestamps
    end
  end
end
