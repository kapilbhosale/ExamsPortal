# == Schema Information
#
# Table name: pending_fees
#
#  id           :bigint(8)        not null, primary key
#  amount       :decimal(, )
#  paid         :boolean          default(FALSE)
#  reference_no :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  student_id   :bigint(8)
#
# Indexes
#
#  index_pending_fees_on_student_id  (student_id)
#

class PendingFee < ApplicationRecord
end
