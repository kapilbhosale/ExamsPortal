class FeeTransactionError < StandardError; end

module Fees
  class CreateFeesTransaction
    attr_reader :create_params, :current_org
    def initialize(create_params, current_org)
      @create_params = create_params
      @current_org = current_org
    end

    def create
      validate_request
      ActiveRecord::Base.transaction do

      end
    rescue FeeTransactionError, ActiveRecord::RecordInvalid => ex
      return { status: false, message: ex.message }
    end

    private
    def validate_request
      raise FeeTransactionError, 'Name must be present' if name.nil?
      raise FeeTransactionError, 'Name already taken' if name_already_taken?
    end
  end
end
