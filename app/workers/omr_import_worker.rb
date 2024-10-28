class OmrImportWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'critical', retry: 1

  def perform(file_path, branch)
    REDIS_CACHE.set("omr-import-info-time", "Importing data...")
    REDIS_CACHE.set("omr-import-info-status", "in-progress")

    Omr::ImportService.new(file_path, branch).call

    REDIS_CACHE.set("omr-import-info-status", "completed")

    last_test = Omr::Test.order(:test_date).last

    REDIS_CACHE.set("omr-import-info-time", DateTime.now.strftime("%d-%B-%Y %I:%M%p"))
    REDIS_CACHE.set("omr-import-info-total_tests", Omr::Test.count)
    REDIS_CACHE.set("omr-import-info-last_test_name", last_test&.test_name)
    REDIS_CACHE.set("omr-import-info-last_test_desc", last_test&.description)
    REDIS_CACHE.set("omr-import-info-last_test_date", last_test&.test_date&.strftime("%d-%B-%Y %I:%M%p"))
  end
end
