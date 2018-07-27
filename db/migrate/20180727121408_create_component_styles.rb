class CreateComponentStyles < ActiveRecord::Migration[5.2]
  def change
    create_table :component_styles do |t|
      t.references :component, polymorphic: true, index: true
      t.text :style
      t.timestamps
    end
  end
end
