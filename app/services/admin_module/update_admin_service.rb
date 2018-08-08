class UpdateAdminError < StandardError; end

module AdminModule
  class UpdateAdminService
    attr_reader :admin, :params
    def initialize(params)
      @admin = Admin.find_by(id: params[:id])
      @params = params
    end

    def update
      validate_request
      admin.update!({email: params[:admin][:email]})
      return {status: true, message: 'Details updated successfully'}
    rescue UpdateAdminError, ActiveRecord::RecordInvalid => ex
      return {status: false, message: ex.message}
    end

    private

    def validate_request
      raise UpdateAdminError, 'Admin does not exists' if admin.blank?
    end
  end
end
