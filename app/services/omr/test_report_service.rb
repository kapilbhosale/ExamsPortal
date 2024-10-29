class Omr::TestReportService
  attr_reader :test, :batch_ids, :include_absents, :report_type

  def initialize(test, batch_ids, include_absents, report_type)
    @test = test
    @batch_ids = batch_ids
    @include_absents = include_absents
    @report_type = report_type
  end

  def call
    if include_absents
      test_data = get_data_with_absents
    else
      test_data = get_data_without_absents
    end

    {status: true, test_data: test_data}
  # rescue StandardError => ex
  #   Rails.logger.error ex.message
  #   return {status: false, message: ex.message}
  end

  def get_data_without_absents
    student_tests = Omr::StudentTest
      .where(omr_test_id: @test.id)
      .joins(omr_student: :omr_batches)
      .where(omr_batches: { id: batch_ids })

    if report_type == 'roll_number'
      student_tests = student_tests.order('omr_students.roll_number ASC')
    elsif report_type == 'name'
      student_tests = student_tests.order('omr_students.name ASC')
    else
      student_tests = student_tests.order(rank: :asc)
    end

    test_data = []
    student_tests.each.with_index do |student_test, idx|
      test_data << {
        sr_no: idx + 1,
        roll_number: student_test.omr_student.roll_number,
        name: student_test.omr_student.name,
        score: student_test.score,
        rank: student_test.rank,
        data: clean_data(student_test.data)
      }
    end
    return test_data
  end

  def get_data_with_absents
    if report_type == 'roll_number'
      all_students = Omr::Student.joins(:omr_batches).where(omr_batches: { id: batch_ids }).order(:roll_number)
      return common_absent_data(all_students)
    end
    if report_type == 'name'
      all_students = Omr::Student.joins(:omr_batches).where(omr_batches: { id: batch_ids }).order(:name)
      return common_absent_data(all_students)
    end
    absent_data_with_rank
  end

  def absent_data_with_rank
    student_tests = Omr::StudentTest
      .where(omr_test_id: @test.id)
      .joins(omr_student: :omr_batches)
      .where(omr_batches: { id: batch_ids })
      .order(rank: :asc)

    all_students = Omr::Student.joins(:omr_batches).where(omr_batches: { id: batch_ids }).order(:name)
    absent_students = all_students - student_tests.map(&:omr_student)

    test_data = []
    student_tests.each.with_index do |student_test, idx|
      test_data << {
        sr_no: idx + 1,
        roll_number: student_test.omr_student.roll_number,
        name: student_test.omr_student.name,
        score: student_test.score,
        rank: student_test.rank,
        data: clean_data(student_test.data)
      }
    end

    absent_students.each do |student|
      test_data << {
        sr_no: test_data.size + 1,
        roll_number: student.roll_number,
        name: student.name,
        score: '-',
        rank: 'AB',
        data: {}
      }
    end

    return test_data
  end

  def common_absent_data(all_students)
    student_tests_by_student_id = Omr::StudentTest
      .where(omr_test_id: @test.id)
      .joins(omr_student: :omr_batches)
      .where(omr_batches: { id: batch_ids })
      .order(rank: :asc)
      .index_by { |st| st.omr_student.id }

    test_data = []
    all_students.each_with_index do |student, idx|
      student_test = student_tests_by_student_id[student.id]
      if student_test.present?
        test_data << {
        sr_no: idx + 1,
        roll_number: student_test.omr_student.roll_number,
        name: student_test.omr_student.name,
        score: student_test.score,
        rank: student_test.rank,
        data: clean_data(student_test.data)
      }
      else
        test_data << {
          sr_no: idx + 1,
          roll_number: student.roll_number,
          name: student.name,
          score: '-',
          rank: '-',
          data: {}
        }
      end
    end

    return test_data
  end

  def clean_data(data)
    cleaned_data = {}
    data.each do |key, value|
      cleaned_data[Omr::Test.get_subject_code(key)] = value
    end
    cleaned_data
  end
end
