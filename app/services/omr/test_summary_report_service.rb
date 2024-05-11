class Omr::TestSummaryReportService
  attr_reader :test, batch_ids

  def initialize(test, batch_ids)
    @test = test
    @batch_ids = batch_ids
  end

  def call
  rescue StandardError => ex
    Rails.logger.error ex.message
    return {status: false, message: ex.message}
  end
end
