# frozen_string_literal: true

class Api::V1::StudyPdfsController < Api::V1::ApiController

  def index
    json_data = {
      'Exam Paper PDF' => exam_data,
      'DPP' => dpp_data
    }
    render json: json_data, status: :ok
  end

  private

  def exam_data
    StudyPdf.where(org: current_org).exam_papers.map do |spdf|
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
    StudyPdf.where(org: current_org).dpp.map do |spdf|
      {
        name: spdf.name,
        description: spdf.description,
        added_on: spdf.created_at.strftime("%d-%B-%Y %I:%M%p"),
        solution_paper_link: spdf.solution_paper.url
      }
    end
  end
end
