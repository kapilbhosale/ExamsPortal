class ReportPrintStatus < ApplicationRecord
  belongs_to :admin
  validates :report_type, presence: true
  validates :branch, presence: true


  enum report_type: {collection_report: 'collection_report', due_fees_report: 'due_fees_report', notes_report: 'notes_report'}
  scope :today, -> { where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day) }
end
