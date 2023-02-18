class Admin::Api::V2::FeesReportsController < Admin::Api::V2::ApiController

  def collection
    render json: { message: 'inalid permissions' } and return unless current_admin.roles.include?('payments')

    from_date = DateTime.parse(params[:dates][0]).in_time_zone.to_date
    to_date = DateTime.parse(params[:dates][1]).in_time_zone.to_date
    nil_fees_only = params[:nilFees] == 'true'
    collection_data = {}

    @fees_transactions = Fees::CollectionReportService.new(current_org, current_admin, from_date, to_date, nil_fees_only).call
    @fees_transactions.each do |ft|
      key = ft.created_at.strftime('%Y-%m-%d')
      collection_data[key] ||= []
      collection_data[key] << ft.as_json
    end

    render json: collection_data
  end
end
