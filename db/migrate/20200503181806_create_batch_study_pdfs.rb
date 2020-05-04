class CreateBatchStudyPdfs < ActiveRecord::Migration[5.2]
  def change
    create_table :batch_study_pdfs do |t|
      t.references :batch
      t.references :study_pdf
      t.timestamps
    end
  end
end
