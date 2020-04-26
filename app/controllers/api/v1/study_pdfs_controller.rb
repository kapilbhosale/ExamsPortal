# frozen_string_literal: true

class Api::V1::StudyPdfsController < Api::V1::ApiController

  def index
    json_data = {
      'Exam Paper PDF' => rcclatur_data,
      'DPP' => dpp_data
    }
    render json: json_data, status: :ok
  end
end

def rcclatur_data
  [
    {
      :name=>"Test 1 (home)",
      :description=>" description of the test -Test 1 (home)",
      :added_on=>"26 april 2020",
      :question_paper_link=>"https://smart-exams-production.s3.ap-south-1.amazonaws.com/Test-1.pdf",
      :solution_paper_link=>"#"},
    {
      :name=>"NEET Test 2(home)",
      :description=>" description of the test -NEET Test 2(home)",
      :added_on=>"26 april 2020",
      :question_paper_link=>"https://smart-exams-production.s3.ap-south-1.amazonaws.com/Neet-Test-2.pdf",
      :solution_paper_link=>"https://smart-exams-production.s3.ap-south-1.amazonaws.com/Neet-Test-2-solution.pdf"},
    {
      :name=>"CET Phy paper 1",
      :description=>" description of the test -CET Phy paper 1",
      :added_on=>"26 april 2020",
      :question_paper_link=>"https://smart-exams-production.s3.ap-south-1.amazonaws.com/CET-Phy-paper-1.pdf",
      :solution_paper_link=>"https://smart-exams-production.s3.ap-south-1.amazonaws.com/CET-Phy-paper-1-solution.pdf"},
    {
      :name=>"CET Chem paper 1",
      :description=>" description of the test -CET Chem paper 1",
      :added_on=>"26 april 2020",
      :question_paper_link=>"https://smart-exams-production.s3.ap-south-1.amazonaws.com/CET-Che-paper-1.pdf",
      :solution_paper_link=>"https://smart-exams-production.s3.ap-south-1.amazonaws.com/CET-Che-paper-1-solution.pdf"},
    {
      :name=>"Test no 03",
      :description=>" description of the test -Test no 03",
      :added_on=>"26 april 2020",
      :question_paper_link=>"https://smart-exams-production.s3.ap-south-1.amazonaws.com/Test-3.pdf",
      :solution_paper_link=>"https://smart-exams-production.s3.ap-south-1.amazonaws.com/Test-3+Solution.pdf"},
    {
      :name=>"JEE test 01",
      :description=>" description of the test -JEE test 01",
      :added_on=>"26 april 2020",
      :question_paper_link=>"https://smart-exams-production.s3.ap-south-1.amazonaws.com/latur-jee-test-03.pdf",
      :solution_paper_link=>"https://smart-exams-production.s3.ap-south-1.amazonaws.com/Latur-MHTCET-23-march-solution.pdf"},
    {
      :name=>"PCB Test 04",
      :description=>" description of the test -PCB Test 04",
      :added_on=>"26 april 2020",
      :question_paper_link=>"https://smart-exams-production.s3.ap-south-1.amazonaws.com/Latur-Test-4.pdf",
      :solution_paper_link=>"https://smart-exams-production.s3.ap-south-1.amazonaws.com/Latur-Test-4-Solution.pdf"},
    {
      :name=>"MHTCET - 22 March",
      :description=>" description of the test -MHTCET - 22 March",
      :added_on=>"26 april 2020",
      :question_paper_link=>"https://smart-exams-production.s3.ap-south-1.amazonaws.com/Latur-MHTCET-23-march.pdf",
      :solution_paper_link=>"https://smart-exams-production.s3.ap-south-1.amazonaws.com/Latur-MHTCET-23-march-solution.pdf"},
    {
      :name=>"RCC-JEE-Phy-23-march",
      :description=>" description of the test -RCC-JEE-Phy-23-march",
      :added_on=>"26 april 2020",
      :question_paper_link=>"https://smart-exams-production.s3.ap-south-1.amazonaws.com/RCC-JEE-Phy-Latur-23-march.pdf",
      :solution_paper_link=>"https://smart-exams-production.s3.ap-south-1.amazonaws.com/RCC-JEE-Phy-Latur-23-march-Solutions.pdf"},
    {
      :name=>"RCC-JEE-Chem-23-march",
      :description=>" description of the test -RCC-JEE-Chem-23-march",
      :added_on=>"26 april 2020",
      :question_paper_link=>"https://smart-exams-production.s3.ap-south-1.amazonaws.com/RCC-JEE-Chem-Latur-23-march.pdf",
      :solution_paper_link=>"https://smart-exams-production.s3.ap-south-1.amazonaws.com/RCC-JEE-Chem-Latur-23-march-solution.pdf"},
    {
      :name=>"Latur PCB test-5 24march",
      :description=>" description of the test -Latur PCB test-5 24march",
      :added_on=>"26 april 2020",
      :question_paper_link=>"https://smart-exams-production.s3.ap-south-1.amazonaws.com/latur-test-5-24-march.pdf",
      :solution_paper_link=>"https://smart-exams-production.s3.ap-south-1.amazonaws.com/latur-test-5-24-march-solution.pdf"},
    {
      :name=>"Exam 26 march",
      :description=>" description of the test -Exam 26 march",
      :added_on=>"26 april 2020",
      :question_paper_link=>"https://smart-exams-production.s3.ap-south-1.amazonaws.com/Test-6+26-03-2020.pdf",
      :solution_paper_link=>"https://smart-exams-production.s3.ap-south-1.amazonaws.com/Test-6+26-03-2020-solution.pdf"}
  ]
end

def dpp_data
  [
    {
      :name=>"Notes Test 1 (home)",
      :description=>" description of the test -Test 1 (home)",
      :added_on=>"26 april 2020",
      :solution_paper_link=>"https://smart-exams-production.s3.ap-south-1.amazonaws.com/Test-1.pdf"},
    {
      :name=>"Notes NEET Test 2(home)",
      :description=>" description of the test -NEET Test 2(home)",
      :added_on=>"26 april 2020",
      :solution_paper_link=>"https://smart-exams-production.s3.ap-south-1.amazonaws.com/Neet-Test-2-solution.pdf"},
    {
      :name=>"Notes CET Phy paper 1",
      :description=>" description of the test -CET Phy paper 1",
      :added_on=>"26 april 2020",
      :solution_paper_link=>"https://smart-exams-production.s3.ap-south-1.amazonaws.com/CET-Phy-paper-1-solution.pdf"},
  ]
end