class Omr::TestReportService
  attr_reader :test, :batch_ids, :exclude_absents, :report_type

  def initialize(test, batch_ids, exclude_absents, report_type)
    @test = test
    @batch_ids = batch_ids
    @exclude_absents = exclude_absents
    @report_type = report_type
  end

  def call
    # if exclude_absents
    # else
    #   all_students = Omr::Student.includes(:omr_batches).where(omr_batches: {id: batch_ids})
    # end

    student_tests = Omr::StudentTest.includes(:omr_student).where(omr_test_id: @test.id).order(rank: :asc)
    test_data = []

    student_tests.each.with_index do |student_test, idx|
      test_data << {
        sr_no: idx + 1,
        roll_number: student_test.omr_student.roll_number,
        name: student_test.omr_student.name,
        score: student_test.score,
        rank: student_test.rank,
        data: student_test.data
      }
    end

    {status: true, test_data: test_data}
  rescue StandardError => ex
    Rails.logger.error ex.message
    return {status: false, message: ex.message}
  end
end
