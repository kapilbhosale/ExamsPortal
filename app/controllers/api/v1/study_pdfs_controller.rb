# frozen_string_literal: true

class Api::V1::StudyPdfsController < Api::V1::ApiController

  def index
    last_tab = current_org.subdomain == 'exams' ? 'Eagle View' : 'Other Notes'
    json_data = {
      'Exam Paper PDF' => exam_data,
      'DPP' => dpp_data,
      last_tab => other_data
    }
    render json: json_data, status: :ok
  end

  private

  def study_pdf_for_student
    @study_pdf_for_student ||= begin
      study_pdf_ids = BatchStudyPdf.where(batch_id: current_student.batches&.ids).pluck(:study_pdf_id)
      StudyPdf.where(id: study_pdf_ids).where(org: current_org)
    end
  end

  def exam_data
    study_pdf_for_student.exam_papers.map do |spdf|
      {
        name: spdf.name,
        description: spdf.description,
        added_on: spdf.created_at.strftime("%d-%B-%Y %I:%M%p"),
        question_paper_link: spdf.question_paper.url,
        solution_paper_link: spdf.solution_paper.url
      }
    end
  end

  def dpp_data
    study_pdf_for_student.dpp.map do |spdf|
      {
        name: spdf.name,
        description: spdf.description,
        added_on: spdf.created_at.strftime("%d-%B-%Y %I:%M%p"),
        solution_paper_link: spdf.solution_paper.url
      }
    end
  end

  def other_data
    study_pdf_for_student.eagle_view.map do |spdf|
      {
        name: spdf.name,
        description: spdf.description,
        added_on: spdf.created_at.strftime("%d-%B-%Y %I:%M%p"),
        solution_paper_link: spdf.solution_paper.url
      }
    end
  end
end
