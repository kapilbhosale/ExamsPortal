class CreateBatchGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :batch_groups do |t|
      t.string      :name
      t.references  :org
      t.timestamps
    end
  end
end
