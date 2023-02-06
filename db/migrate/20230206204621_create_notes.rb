class CreateNotes < ActiveRecord::Migration[5.2]
  def change
    create_table :notes do |t|
      t.references :org
      t.string  :name
      t.string  :description
      t.timestamps
    end
  end
end
