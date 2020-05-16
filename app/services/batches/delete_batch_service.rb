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
      return {status: true, message: 'Batch deleted successfully'}
    rescue DeleteBatchError, ActiveRecord::RecordInvalid => ex
      return{status: false, message: ex.message}
    end

    private

    def validate_request
      raise DeleteBatchError, 'Batch does not exists' if batch.blank?
      raise DeleteBatchError, 'Can not delete batch, org mismatch' if batch.org_id != org.id
    end
  end
end
