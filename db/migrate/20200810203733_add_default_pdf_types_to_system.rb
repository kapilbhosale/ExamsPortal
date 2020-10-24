class AddDefaultPdfTypesToSystem < ActiveRecord::Migration[5.2]
  def change
    Org.all.each do |org|
      StudyPdfType.find_or_create_by(
        name: 'Exam papers',
        pdf_type: StudyPdfType.pdf_types[:qna],
        org_id: org.id
      )

      StudyPdfType.find_or_create_by(
        name: 'Notes',
        pdf_type: StudyPdfType.pdf_types[:single_link],
        org_id: org.id
      )
    end
  end
end
