class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.references :org
      t.string :title
      t.string :description
      t.timestamps
    end
  end
end
