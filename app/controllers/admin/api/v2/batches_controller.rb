class Admin::Api::V2::BatchesController < Admin::Api::V2::ApiController
  def index
    batch_ids = BatchFeesTemplate.where(batch_id: current_admin.batches.ids).pluck(:batch_id)
    @batches = Batch
      .where(org_id: current_org.id)
      .where(edu_year: current_org.data['current_academic_year'] || FeesTransaction::CURRENT_ACADEMIC_YEAR)
      .where(id: batch_ids)
      .includes(:batch_group).order(:created_at)
  end
end
