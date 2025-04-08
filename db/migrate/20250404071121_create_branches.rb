class CreateBranches < ActiveRecord::Migration[5.2]
  def change
    create_table :branches do |t|
      t.references :org, foreign_key: true, index: true
      t.string :name, null: false
      t.string :code, null: false
      t.string :address

      t.timestamps
    end
  end
end
