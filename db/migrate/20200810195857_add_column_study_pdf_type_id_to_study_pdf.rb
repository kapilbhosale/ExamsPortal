class AddColumnStudyPdfTypeIdToStudyPdf < ActiveRecord::Migration[5.2]
  def change
    add_column :study_pdfs, :study_pdf_type_id, :integer
    add_index :study_pdfs, :study_pdf_type_id
  end
end
