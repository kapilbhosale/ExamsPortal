class CreateFormData < ActiveRecord::Migration[5.2]
  def change
    create_table :form_data do |t|
      t.references :student
      t.string :form_id
      t.jsonb :data, default: {}
      t.timestamps
    end
  end
end
