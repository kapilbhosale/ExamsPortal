class Admin::Api::V2::FeesReportsController < Admin::Api::V2::ApiController

  def collection
    render json: { message: 'invalid permissions' } and return unless current_admin.roles.include?('payments')

    from_date = DateTime.parse(params[:dates][0]).in_time_zone.to_date
    to_date = DateTime.parse(params[:dates][1]).in_time_zone.to_date
    nil_fees_only = params[:nilFees] == 'true'
    branch = params[:branch]
    payment_type = params[:paymentType]
    collection_data = {}

    @fees_transactions = Fees::CollectionReportService.new(current_org, current_admin, from_date, to_date, nil_fees_only, branch, payment_type).call
    @fees_transactions.each do |ft|
      key = ft.created_at.strftime('%Y-%m-%d')
      collection_data[key] ||= []
      collection_data[key] << ft.as_json
    end

    render json: collection_data
  end

  def collection_csv
    render json: { message: 'invalid permissions' } and return unless current_admin.roles.include?('payments')

    from_date = DateTime.parse(params[:dates][0]).in_time_zone.to_date
    to_date = DateTime.parse(params[:dates][1]).in_time_zone.to_date
    nil_fees_only = params[:nilFees] == 'true'
    branch = params[:branch]
    payment_type = params[:paymentType]
    collection_data = {}

    @fees_transactions = Fees::CollectionReportService.new(current_org, current_admin, from_date, to_date, nil_fees_only, branch, payment_type).call
    csv_data = CSV.generate(headers: true) do |csv|
      csv << ["Date", "roll_number", "name", "parent_mobile", "gender", "batch", "receipt_number", "paid_amount", "base_fee", "cgst", "sgst", "tax", "collected_by", "remaining_amount", "discount_amount", "discount_comment", "next_due_date"]
      @fees_transactions.each do |ft|
        csv << [
          ft.created_at.strftime('%Y-%m-%d'),
          ft.student.roll_number,
          ft.student.name,
          ft.student.parent_mobile,
          ft.student.gender == 0 ? 'Male' : 'Female' ,
          ft.student.batches.joins(:fees_templates).pluck(:name).join(', '),
          ft.receipt_number,
          ft.paid_amount.to_f.round(2),
          (ft.paid_amount + ft.remaining_amount).round(2),
          ft.payment_details.dig('totals', 'cgst').to_f.round(2),
          ft.payment_details.dig('totals', 'sgst').to_f.round(2),
          (ft.payment_details.dig('totals', 'cgst').to_f + ft.payment_details.dig('totals', 'sgst').to_f).round(2),
          ft.admin.name,
          ft.remaining_amount.to_f.round(2),
          ft.discount_amount.to_f.round(2),
          ft.comment,
          ft.next_due_date&.strftime('%Y-%m-%d')
        ]
      end
    end

    send_data csv_data, type: 'text/csv', filename: 'collection_report.csv'
  end

  def due_fees
    render json: { message: 'invalid permissions' } and return unless current_admin.roles.include?('payments-due')

    from_date = DateTime.parse(params[:dates][0]).in_time_zone.to_date
    to_date = DateTime.parse(params[:dates][1]).in_time_zone.to_date
    branch = params[:branch]
    due_fees_data = {}

    @fees_transactions = Fees::DueFeesReportService.new(current_org, current_admin, from_date, to_date, branch).call
    @fees_transactions.each do |ft|
      key = ft.next_due_date.strftime('%Y-%m-%d')
      due_fees_data[key] ||= []
      due_fees_data[key] << ft.as_json
    end

    render json: due_fees_data
  end

  def due_fees_csv
    render json: { message: 'invalid permissions' } and return unless current_admin.roles.include?('payments-due')

    from_date = DateTime.parse(params[:dates][0]).in_time_zone.to_date
    to_date = DateTime.parse(params[:dates][1]).in_time_zone.to_date
    branch = params[:branch]
    due_fees_data = {}

    @fees_transactions = Fees::DueFeesReportService.new(current_org, current_admin, from_date, to_date, branch).call

    csv_data = CSV.generate(headers: true) do |csv|
      csv << ["roll_number", "name", "parent_mobile", "gender", "batch", "Due Date", "Due Amount"]
      @fees_transactions.each do |ft|
        csv << [
          ft.student.roll_number,
          ft.student.name,
          ft.student.parent_mobile,
          ft.student.gender == 0 ? 'Male' : 'Female' ,
          ft.student.batches.joins(:fees_templates).pluck(:name).join(', '),
          ft.remaining_amount.to_f.round(2),
          ft.next_due_date&.strftime('%Y-%m-%d')
        ]
      end
    end

    send_data csv_data, type: 'text/csv', filename: 'due_date_report.csv'
  end

  def notes
    render json: { message: 'invalid permissions' } and return unless current_admin.roles.include?('notes')

    notes_data = {}
    @notes = Note.all.index_by(&:id)
    StudentNote.where(created_at: Time.current.all_day).group(:note_id).count.each do |key, value|
      notes_data[key] = {
        id:  @notes[key].id,
        name: @notes[key].name,
        count:  value,
        date: Time.current.strftime('%d/%b/%Y')
      }
    end

    render json: notes_data
  end
end
