class AddBatchError < StandardError; end

module Batches
  class AddBatchService
    attr_reader :name, :org

    def initialize(name, org)
      @name = name
      @org = org
    end

    def call
      validate_request
      batch = Batch.create!(name: name)
      return {status: true, message: 'Batch added successfully'}
    rescue AddBatchError, ActiveRecord::RecordInvalid => ex
      return {status: false, message: ex.message}
    end

    private

    def validate_request
      raise AddBatchError, 'Batch name must be present' if name.blank?
      raise AddBatchError, 'Batch name already exists' if already_exists?
    end

    def already_exists?
      Batch.find_by(name: name).present?
    end
  end
end
