class OmrImportWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'critical', retry: 1

  def perform(file_path, branch)
    REDIS_CACHE.set("omr-import-info-time", "Importing data...")
    REDIS_CACHE.set("omr-import-info-status", "in-progress")

    Omr::ImportService.new(file_path, branch).call

    REDIS_CACHE.set("omr-import-info-status", "completed")

    REDIS_CACHE.set("omr-import-info-time", DateTime.now.strftime("%d-%B-%Y %I:%M%p"))
    REDIS_CACHE.set("omr-import-info-total_tests", Omr::Test.count)
    REDIS_CACHE.set("omr-import-info-last_test_name", Omr::Test.last&.test_name)
    REDIS_CACHE.set("omr-import-info-last_test_desc", Omr::Test.last&.test_desc)
    REDIS_CACHE.set("omr-import-info-last_test_date", Omr::Test.last&.test_date&.strftime("%d-%B-%Y %I:%M%p"))
  end
end
