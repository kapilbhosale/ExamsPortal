module Fees
  class CollectionReportService
    attr_reader :current_org, :from_date, :to_date, :current_admin, :nil_fees_only

    def initialize(current_org, current_admin, from_date, to_date, nil_fees_only)
      @current_org = current_org
      @current_admin = current_admin
      @from_date = from_date
      @to_date = to_date
      @nil_fees_only = nil_fees_only
    end

    def call
      return today_transactions if from_date == to_date && to_date == Date.today

      if to_date < Date.today
        return transactions_between_dates(from_date, to_date)
      end

      if to_date == Date.today
        return (transactions_between_dates(from_date, to_date - 1.day) + today_transactions)
      end

      today_transactions
    end

    private

    def today_transactions
      transactions = FeesTransaction.includes(:admin, student: [:batches])
        .current_year.today
        .where(org_id: current_org.id)

      return transactions unless nil_fees_only

      transactions.where(remaining_amount: 0)
    end

    def transactions_between_dates(date1, date2)
      fees_transactions = FeesTransaction.includes(:admin, student: [:batches])
      unless current_admin.roles.include?('ff')
        fees_transactions = fees_transactions.lt_hundred
      end

      fees_transactions = fees_transactions.current_year
        .where(org_id: current_org.id)
        .where('created_at >= ?', date1)
        .where('created_at <= ?', date2)
      return fees_transactions unless nil_fees_only

      fees_transactions.where(remaining_amount: 0)
    end
  end
end
