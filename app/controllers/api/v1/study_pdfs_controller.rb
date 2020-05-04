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
    [
      {
        :name=>"Test PDF",
        :description=>"description of the test -Test 1 (home)",
        :added_on=>"26 april 2020",
        :question_paper_link=>"https://smart-exams-production.s3.ap-south-1.amazonaws.com/apks/dhote-sample.pdf",
        :solution_paper_link=>"https://smart-exams-production.s3.ap-south-1.amazonaws.com/apks/dhote-sample.pdf"
      }
    ]
  end

  def dpp_data
    [
      {
        :name=>"Notes Test 1 (home)",
        :description=>" description of the test -Test 1 (home)",
        :added_on=>"26 april 2020",
        :solution_paper_link=>"https://smart-exams-production.s3.ap-south-1.amazonaws.com/apks/dhote-sample.pdf"
      },
    ]
  end
end
