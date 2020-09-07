class Students::StudyPdfsController < Students::BaseController
  before_action :authenticate_student!

  def index
    study_pdf_ids = BatchStudyPdf.where(batch_id: current_student.batches&.ids).pluck(:study_pdf_id)
    study_pdfs = StudyPdf.includes(:study_pdf_type).where(id: study_pdf_ids).where(org: current_org).order(id: :desc)
    @json_data = {}
    study_pdfs.each do |study_pdf|
      @json_data[study_pdf.study_pdf_type&.name || 'Default'] ||= []
      @json_data[study_pdf.study_pdf_type&.name || 'Default'] << {
        name: study_pdf.name,
        description: study_pdf.description,
        added_on: study_pdf.created_at.strftime("%d-%B-%Y %I:%M%p"),
        question_paper_link: study_pdf.question_paper.url,
        solution_paper_link: study_pdf.solution_paper.url
      }
    end
  end
end
