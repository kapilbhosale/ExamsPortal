class CreateFeesTemplates < ActiveRecord::Migration[5.2]
  def change
    create_table :fees_templates do |t|
      t.references  :org
      t.string      :name, unique: true
      t.string      :description
      t.jsonb       :heads, default: {}
      t.timestamps
    end
  end
end
