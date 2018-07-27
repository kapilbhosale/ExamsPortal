class CreateSubjects < ActiveRecord::Migration[5.2]
  def change
    create_table :subjects do |t|
      t.string :name, null: false
      t.string :name_map, null: false, index: true
      t.timestamps
    end
  end
end
