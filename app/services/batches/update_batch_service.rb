class UpdateBatchError < StandardError; end

module Batches
  class UpdateBatchService
    attr_reader :batch, :name, :batch_group_id

    def initialize(id, name, batch_group_id)
      @batch = Batch.find_by(id: id)
      @name = name
      @batch_group_id = batch_group_id
    end

    def call
      validate_request
      batch.update!(name: name, batch_group_id: batch_group_id)
      { status: true, message: 'Batch updated successfully' }
    rescue UpdateBatchError, ActiveRecord::RecordInvalid => ex
      { status: false, message: ex.message }
    end

    private

    def validate_request
      raise UpdateBatchError, 'Name must be present' if name.blank?
      # raise UpdateBatchError, 'Batch with this name already exists' if name_already_taken?
      raise UpdateBatchError, 'Batch does not exist' if batch.blank?
    end

    # def name_already_taken?
    #   Batch.find_by(name: name).present?
    # end
  end
end
