class CreateStudyPdfTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :study_pdf_types do |t|
      t.string  :name, null: false
      t.integer :pdf_type, default: 0, null: false
      t.references :org

      t.timestamps
    end
  end
end
