# == Schema Information
#
# Table name: batch_banners
#
#  id         :bigint(8)        not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  banner_id  :bigint(8)
#  batch_id   :bigint(8)
#
# Indexes
#
#  index_batch_banners_on_banner_id  (banner_id)
#  index_batch_banners_on_batch_id   (batch_id)
#

class BatchBanner < ApplicationRecord
  belongs_to :banner
  belongs_to :batch
end
