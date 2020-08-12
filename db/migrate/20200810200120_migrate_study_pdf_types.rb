class MigrateStudyPdfTypes < ActiveRecord::Migration[5.2]
  def change
    StudyPdf.connection.schema_cache.clear!
    StudyPdf.reset_column_information

    StudyPdf.all.each do |study_pdf|
      if study_pdf.exam_papers?
        study_pdf_type = StudyPdfType.find_or_create_by(
          name: 'Exam papers',
          pdf_type: StudyPdfType.pdf_types[:qna],
          org_id: study_pdf.org_id
        )
      end
      if study_pdf.eagle_view?
        study_pdf_type = StudyPdfType.find_or_create_by(
          name: 'Eagle View',
          pdf_type: StudyPdfType.pdf_types[:single_link],
          org_id: study_pdf.org_id
        )
      end
      if study_pdf.dpp?
        study_pdf_type = StudyPdfType.find_or_create_by(
          name: 'DPP',
          pdf_type: StudyPdfType.pdf_types[:single_link],
          org_id: study_pdf.org_id
        )
      end

      study_pdf.study_pdf_type_id = study_pdf_type.id
      study_pdf.save
    end
  end
end
