class OmrImportWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'critical', retry: 1

  def perform(file_path, branch)
    Rails.logger.info "OmrImportWorker started with file: #{file_path} and branch: #{branch}"

    REDIS_CACHE.set("omr-import-info-time", "Importing data...")
    REDIS_CACHE.set("omr-import-info-status", "in-progress")

    unless File.exist?(file_path)
      Rails.logger.error "File not found: #{file_path}"
      REDIS_CACHE.set("omr-import-info-status", "failed")
      return
    end

    begin
      Omr::ImportService.new(file_path, branch).call
      REDIS_CACHE.set("omr-import-info-status", "completed")

      last_test = Omr::Test.order(:test_date).last

      REDIS_CACHE.set("omr-import-info-time", DateTime.now.strftime("%d-%B-%Y %I:%M%p"))
      REDIS_CACHE.set("omr-import-info-total_tests", Omr::Test.count)
      REDIS_CACHE.set("omr-import-info-last_test_name", last_test&.test_name)
      REDIS_CACHE.set("omr-import-info-last_test_desc", last_test&.description)
      REDIS_CACHE.set("omr-import-info-last_test_date", last_test&.test_date&.strftime("%d-%B-%Y %I:%M%p"))
    rescue StandardError => e
      Rails.logger.error "OmrImportWorker encountered an error: #{e.message}"
      REDIS_CACHE.set("omr-import-info-status", "failed")
    end

    Rails.logger.info "OmrImportWorker completed for file: #{file_path} and branch: #{branch}"
  end
end
