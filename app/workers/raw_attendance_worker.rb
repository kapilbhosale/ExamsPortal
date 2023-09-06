class RawAttendanceWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'critical', retry: 2

  def perform(ra_id)
    ra = RawAttendance.find_by(id: ra_id)
    ra.process_raw_attendance if ra
  end
end
