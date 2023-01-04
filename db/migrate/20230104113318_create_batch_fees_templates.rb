class CreateBatchFeesTemplates < ActiveRecord::Migration[5.2]
  def change
    create_table :batch_fees_templates do |t|
      t.references :fees_template
      t.references :batch
      t.timestamps
    end

    add_index :batch_fees_templates, [:fees_template_id, :batch_id], unique: true, name: :batch_fees_template_index
  end
end
