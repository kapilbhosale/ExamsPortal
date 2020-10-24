class CreateStudyPdfs < ActiveRecord::Migration[5.2]
  def change
    create_table :study_pdfs do |t|
      t.references :org
      t.string :name
      t.string :description
      t.string :question_paper
      t.string :solution_paper
      t.integer :pdf_type, default: 0
      t.timestamps
    end
  end
end
