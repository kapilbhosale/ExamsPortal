# frozen_string_literal: true

class Api::V1::StudyPdfsController < Api::V1::ApiController
  USE_CACHE = true
  def index
    if current_student.batches&.ids&.count == 1
      batch_id = current_student.batches&.ids.first
      cache_key = "BatchStudyPdf-batch-id-#{batch_id}"

      batch_pdfs = REDIS_CACHE.get(cache_key)
      if USE_CACHE && batch_pdfs.present?
        render json: JSON.parse(batch_pdfs), status: :ok and return
      else
        batch_pdfs = get_pdfs()
        REDIS_CACHE.set(cache_key, JSON.dump(batch_pdfs), { ex: 1.day })
        render json: batch_pdfs, status: :ok and return
      end
    end

    json_data = get_pdfs()
    render json: json_data, status: :ok
  end

  private

  def get_pdfs
    study_pdf_ids = BatchStudyPdf.where(batch_id: current_student.batches&.ids).pluck(:study_pdf_id)
    study_pdfs = StudyPdf.includes(:study_pdf_type).where(id: study_pdf_ids).where(org: current_org).order(id: :desc)
    json_data = {}
    study_pdfs.each do |study_pdf|
      json_data[study_pdf.study_pdf_type&.name || 'Default'] ||= []
      json_data[study_pdf.study_pdf_type&.name || 'Default'] << {
        name: study_pdf.name,
        description: study_pdf.description,
        added_on: study_pdf.created_at.strftime("%d-%B-%Y %I:%M%p"),
        question_paper_link: study_pdf.question_paper.url,
        solution_paper_link: study_pdf.solution_paper.url
      }
    end
    json_data
  end
end
