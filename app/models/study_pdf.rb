# == Schema Information
#
# Table name: study_pdfs
#
#  id             :bigint(8)        not null, primary key
#  description    :string
#  name           :string
#  pdf_type       :integer          default("exam_papers")
#  question_paper :string
#  solution_paper :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  org_id         :bigint(8)
#
# Indexes
#
#  index_study_pdfs_on_org_id  (org_id)
#

class StudyPdf < ApplicationRecord
  mount_uploader :question_paper, PdfUploader
  mount_uploader :solution_paper, PdfUploader

  enum pdf_type: { exam_papers: 0, eagle_view: 1, dpp: 2 }
end
