# == Schema Information
#
# Table name: study_pdfs
#
#  id                :bigint(8)        not null, primary key
#  description       :string
#  name              :string
#  pdf_type          :integer          default("single_link")
#  question_paper    :string
#  solution_paper    :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  genre_id          :bigint(8)
#  org_id            :bigint(8)
#  study_pdf_type_id :integer
#  subject_id        :bigint(8)
#
# Indexes
#
#  index_study_pdfs_on_genre_id           (genre_id)
#  index_study_pdfs_on_org_id             (org_id)
#  index_study_pdfs_on_study_pdf_type_id  (study_pdf_type_id)
#  index_study_pdfs_on_subject_id         (subject_id)
#
# Foreign Keys
#
#  fk_rails_...  (subject_id => subjects.id)
#

class StudyPdf < ApplicationRecord
  acts_as_paranoid
  mount_uploader :question_paper, PdfUploader
  mount_uploader :solution_paper, PdfUploader

  enum pdf_type: { single_link: 0, qna: 1, other: 2 }

  belongs_to :org
  belongs_to :study_pdf_type

  has_many :batch_study_pdfs
  has_many :batches, through: :batch_study_pdfs
  belongs_to :genre, optional: true, counter_cache: true
  belongs_to :subject, optional: true

  # after_create :send_push_notifications

  def send_push_notifications
    fcm = FCM.new(org.fcm_server_key)
    batches.each do |batch|
      batch.students.where.not(fcm_token: nil).pluck(:fcm_token).each_slice(500) do |reg_ids|
        fcm.send(reg_ids, push_options)
      end
    end
  end

  def push_options
    {
      priority: 'high',
      data: {
        message: 'New PDF Material Added'
      },
      notification: {
        body: "New #{study_pdf_type.name}, Name: #{name}, Please visit and take a look. Study Hard.",
        title: "New #{study_pdf_type.name} Added - '#{name}'",
        image: org.data['push_image']
      }
    }
  end
end
