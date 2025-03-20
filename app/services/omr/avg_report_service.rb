class ValidationError < StandardError; end

class Omr::AvgReportService
  attr_reader :test_ids, :student_type, :student_count

  def initialize(test_ids, student_type, student_count)
    @test_ids = test_ids
    @student_type = student_type
    @student_count = student_count
  end

  def call
    validate_request
    csv_data = generate_report
    OpenStruct.new(success?: true, errors: nil, data: csv_data)
  rescue ValidationError => e
    OpenStruct.new(success?: false, errors: e.message, data: nil)
  end

  private

  def generate_report
    headers = ["Student ID", "Student Name", "Roll Number"]
    test_ids.each do |test_id|
      test = Omr::Test.find(test_id)
      headers << "test.name [#{test.id}]"
      headers << "rank [#{test.id}]"
      test.data['subjects'].keys.each do |subject|
        headers << "#{subject} Score [#{test.id}]"
        headers << "#{subject} Attempt [#{test.id}]"
        headers << "#{subject} Correct [#{test.id}]"
        headers << "#{subject} Wrong [#{test.id}]"
        headers << "#{subject} Skip [#{test.id}]"
      end
    end
    headers << "Total Score"

    students = get_selected_students

    csv_data = CSV.generate(headers: true) do |csv|
      csv << headers
      students.each do |student_id, total_score|
        student = Omr::Student.find(student_id)
        next if student.blank?

        row = [student.id, student.name, student.roll_number]
        test_ids.each do |test_id|
          test = Omr::Test.find(test_id)
          subjects = test.data['subjects']
          student_test = Omr::StudentTest.find_by(omr_test_id: test_id, omr_student_id: student_id)
          if student_test.blank?
            row +=  ["-", "-"] + ["-"] * (subjects.keys.size * 5)
          else
            row << student_test.score
            row << student_test.rank
            subjects.keys.each do |sub|
              row << student_test.data[sub]['score']
              row << student_test.data[sub]['correct_count'] + student_test.data[sub]['wrong_count']
              row << student_test.data[sub]['correct_count']
              row << student_test.data[sub]['wrong_count']
              row << student_test.data[sub]['skip_count']
            end
          end
        end
        row << total_score
        csv << row
      end
    end

    return csv_data
  end

  def get_selected_students
    students_avg = {}
    test_ids.each do |test_id|
      test = Omr::Test.find(test_id)
      test.omr_student_tests.order(score: :desc).limit(500).each do |student_test|
        students_avg[student_test.omr_student_id] ||= 0
        students_avg[student_test.omr_student_id] += student_test.score
      end
    end

    students_avg.sort_by { |_, v| v }.reverse.first(student_count.to_i)
  end

  def validate_request
    errors = []
    errors << 'Test ids are required' if test_ids.blank?
    errors << 'Student type is required' if student_type.blank?
    errors << 'Student count is required' if student_count.blank?

    if errors.present?
      raise ValidationError.new(errors.join(', '))
    end
  end
end
