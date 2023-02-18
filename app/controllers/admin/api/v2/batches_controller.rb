class Admin::Api::V2::BatchesController < Admin::Api::V2::ApiController
  def index
    batch_ids = BatchFeesTemplate.where(batch_id: current_admin.batches.ids).pluck(:batch_id)
    @batches = Batch.where(org_id: current_org.id).where(id: batch_ids).includes(:batch_group)
  end
end
