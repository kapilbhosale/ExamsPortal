class AddBatchError < StandardError; end

module Batches
  class AddBatchService
    attr_reader :name, :org, :batch_group_id

    def initialize(name, org, batch_group_id)
      @name = name
      @org = org
      @batch_group_id = batch_group_id
    end

    def call
      validate_request
      batch = Batch.create!(name: name, org: org, batch_group_id: batch_group_id)
      { status: true, message: 'Batch added successfully', batch: batch }
    rescue AddBatchError, ActiveRecord::RecordInvalid => ex
      { status: false, message: ex.message }
    end

    private

    def validate_request
      raise AddBatchError, 'Batch name must be present' if name.blank?
      raise AddBatchError, 'Batch name already exists' if already_exists?
    end

    def already_exists?
      Batch.find_by(org: org, name: name).present?
    end
  end
end
