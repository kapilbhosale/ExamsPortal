# == Schema Information
#
# Table name: study_pdf_types
#
#  id         :bigint(8)        not null, primary key
#  name       :string           not null
#  pdf_type   :integer          default("single_link"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  org_id     :bigint(8)
#
# Indexes
#
#  index_study_pdf_types_on_org_id  (org_id)
#

class StudyPdfType < ApplicationRecord
  enum pdf_type: { single_link: 0, qna: 1 }
  belongs_to :org
  has_many :study_pdfs
end
