# == Schema Information
#
# Table name: admin_batches
#
#  id         :bigint(8)        not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  admin_id   :bigint(8)
#  batch_id   :bigint(8)
#
# Indexes
#
#  index_admin_batches_on_admin_id  (admin_id)
#  index_admin_batches_on_batch_id  (batch_id)
#

class AdminBatch < ApplicationRecord
  belongs_to :admin
  belongs_to :batch
end
