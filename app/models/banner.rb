# == Schema Information
#
# Table name: banners
#
#  id           :bigint(8)        not null, primary key
#  active       :boolean
#  image        :string
#  on_click_url :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  org_id       :bigint(8)
#
# Indexes
#
#  index_banners_on_org_id  (org_id)
#

class Banner < ApplicationRecord
  mount_uploader :image, PhotoUploader

  belongs_to :org

  has_many :batch_banners
  has_many :batches, through: :batch_banners

  after_create :flush_banner_cache

  private

  def flush_banner_cache
    REDIS_CACHE.keys('BA-*').each do |cache_key|
      REDIS_CACHE.del(cache_key)
    end
  end

end
