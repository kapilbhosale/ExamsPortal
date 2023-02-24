class DeleteBatchError < StandardError; end

module Batches
  class DeleteBatchService
    attr_reader :batch, :org

    def initialize(id, org)
      @batch = Batch.find_by(id: id)
      @org = org
    end

    def call
      validate_request
      batch.destroy!
      # mark students with no batch as deleted one. paranoid gem.
      delete_associated_students
      return {status: true, message: 'Batch deleted successfully'}
    rescue DeleteBatchError, ActiveRecord::RecordInvalid => ex
      return{status: false, message: ex.message}
    end

    private

    def delete_associated_students
      Student.includes(:batches).where(batches: { id: nil }).where(deleted_at: nil).update_all(deleted_at: Time.now)
    end

    def validate_request
      raise DeleteBatchError, 'Batch does not exists' if batch.blank?
      raise DeleteBatchError, 'Can not delete batch, org mismatch' if batch.org_id != org.id
      raise DeleteBatchError, 'Can not delete batch, Fees templates assigned' if batch.fees_templates.present?
    end
  end
end
