module Fees
  class DueFeesReportService
    attr_reader :current_org, :from_date, :to_date, :current_admin, :branch

    def initialize(current_org, current_admin, from_date, to_date, branch)
      @current_org = current_org
      @current_admin = current_admin
      @from_date = from_date
      @to_date = to_date
      @branch = branch
    end

    def call
      transactions_between_dates(from_date, to_date)
    end

    private

    def valid_batch_ids
      return current_admin.batches.joins(:fees_templates).ids if branch.blank? || branch == 'all'

      Batch.where(branch: branch).ids & current_admin.batches.joins(:fees_templates).ids
    end

    def transactions_between_dates(date1, date2)
      fees_transactions = FeesTransaction.with_deleted.includes(:admin, student: [:batches, :student_batches])
      unless current_admin.roles.include?('ff')
        fees_transactions = fees_transactions.lt_hundred
      end

      fees_transactions = fees_transactions.current_year
        .where(org_id: current_org.id)
        .where('fees_transactions.next_due_date >= ?', date1)
        .where('fees_transactions.next_due_date <= ?', date2)
        .where(students: { student_batches: { batch_id: valid_batch_ids }})
        .where('remaining_amount > 0')

      return fees_transactions
    end
  end
end
