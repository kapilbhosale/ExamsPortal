# == Schema Information
#
# Table name: batch_study_pdfs
#
#  id           :bigint(8)        not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  batch_id     :bigint(8)
#  study_pdf_id :bigint(8)
#
# Indexes
#
#  index_batch_study_pdfs_on_batch_id      (batch_id)
#  index_batch_study_pdfs_on_study_pdf_id  (study_pdf_id)
#

class BatchStudyPdf < ApplicationRecord
  belongs_to :batch
  belongs_to :study_pdf
end
