class AddColumnSubjectToStudyPdf < ActiveRecord::Migration[5.2]
  def change
    add_reference :study_pdfs, :subject, foreign_key: true
  end
end
