# == Schema Information
#
# Table name: report_print_statuses
#
#  id          :bigint(8)        not null, primary key
#  report_type :string
#  status      :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  admin_id    :bigint(8)
#  branch_id   :integer          default(1), not null
#
# Indexes
#
#  index_report_print_statuses_on_admin_id   (admin_id)
#  index_report_print_statuses_on_branch_id  (branch_id)
#
# Foreign Keys
#
#  fk_rails_...  (admin_id => admins.id)
#

class ReportPrintStatus < ApplicationRecord
  belongs_to :admin
  belongs_to :branch
  validates :report_type, presence: true
  validates :branch, presence: true


  enum report_type: {collection_report: 'collection_report', due_fees_report: 'due_fees_report', notes_report: 'notes_report'}
  scope :today, -> { where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day) }
end
