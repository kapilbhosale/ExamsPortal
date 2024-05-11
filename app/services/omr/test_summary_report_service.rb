class Omr::TestSummaryReportService
  attr_reader :test

  def initialize(test)
    @test = test
  end

  def call
  rescue StandardError => ex
    Rails.logger.error ex.message
    return {status: false, message: ex.message}
  end
end
