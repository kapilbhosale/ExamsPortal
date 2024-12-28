class AddBatchError < StandardError; end

module Batches
  class AddBatchService
    attr_reader :name, :org, :batch_group_id, :start_time, :end_time, :device_ids, :fees_template_ids, :klass, :branch

    def initialize(batch_params, org, batch_group_id, klass, branch)
      @name = batch_params[:name]
      @start_time = batch_params[:start_time]
      @end_time = batch_params[:end_time]
      @device_ids = batch_params[:device_ids]
      @fees_template_ids = batch_params[:fees_template_ids]
      @org = org
      @batch_group_id = batch_group_id
      @klass = klass
      @branch = branch
    end

    def call
      validate_request
      batch = Batch.create!(
        name: name,
        start_time: start_time,
        end_time: end_time,
        device_ids: device_ids,
        org: org,
        batch_group_id: batch_group_id,
        klass: klass,
        branch: branch,
        edu_year: org.data['current_academic_year']
      )
      batch.fees_templates << FeesTemplate.where(id: fees_template_ids)

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
