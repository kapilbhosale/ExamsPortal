# == Schema Information
#
# Table name: progress_reports
#
#  id          :bigint(8)        not null, primary key
#  data        :jsonb
#  exam_date   :date
#  exam_name   :string
#  exam_type   :integer          default("objective")
#  is_imported :boolean          default(FALSE)
#  percentage  :decimal(, )
#  rank        :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  exam_id     :bigint(8)
#  student_id  :bigint(8)
#
# Indexes
#
#  index_progress_reports_on_exam_id     (exam_id)
#  index_progress_reports_on_student_id  (student_id)
#

class ProgressReport < ApplicationRecord
  enum exam_type: { objective: 0, theory: 1 }
  belongs_to :exam, optional: true
  belongs_to :student
end
