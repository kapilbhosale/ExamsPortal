class DeleteBatchError < StandardError; end

module Batches
  class DeleteBatchService
    attr_reader :batch

    def initialize(id)
      @batch = Batch.find_by(id: id)
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
    end
  end
end
