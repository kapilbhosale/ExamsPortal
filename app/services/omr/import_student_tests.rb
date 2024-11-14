# file_path = '/Users/kapilbhosale/Downloads/test_zip/Test_Detail.csv'
# Omr::ImportStudentTests.new(1, 'latur', file_path, Omr::Test.all.pluck(:id)).call

class Omr::ImportStudentTests
  attr_reader :org_id, :branch, :file_path, :tests_to_process

  def initialize(org_id, branch, file_path, tests_to_process)
    @org_id = org_id
    @branch = branch
    @file_path = file_path
    @tests_to_process = tests_to_process
  end

  def call
    csv_file = File.open(file_path, "r:ISO-8859-1")
    return if tests_to_process.empty?

    new_student_tests = []
    batch_size = 10000
    student_id_mapping = Omr::Student.where(org_id: org_id, branch: branch).pluck(:old_id, :id).to_h
    test_id_mapping = Omr::Test.where(org_id: org_id, branch: branch).pluck(:old_id, :id).to_h

    begin
      CSV.foreach(csv_file, :headers => true).each do |csv_row|
        test_id = test_id_mapping[csv_row['Test_ID'].to_i]
        student_id = student_id_mapping[csv_row['Student_ID'].to_i]
        next if test_id.nil? || student_id.nil?
        next unless tests_to_process.include?(test_id)

        student_ans = csv_row['Student_ans_key']
        score = csv_row['Student_Marks'].to_i
        rank = csv_row['Rank'].to_i
        child_test_id = test_id_mapping[csv_row['ChildTestID'].to_i]

        new_student_tests << {
          omr_student_id: student_id,
          omr_test_id: test_id,
          student_ans: student_ans,
          score: score,
          rank: rank,
          child_test_id: (test_id == child_test_id ? nil : child_test_id)
        }

        if new_student_tests.size >= batch_size
          Omr::StudentTest.import new_student_tests, on_duplicate_key_ignore: true
          new_student_tests.clear
        end
      end

      # Insert any remaining entries
      Omr::StudentTest.import new_student_tests, validate: false unless new_student_tests.empty?
    rescue CSV::MalformedCSVError => e
      puts "CSV parsing error: #{e.message}"
    ensure
      csv_file.close
    end
  end
end


# def process_student_tests
#   file_path = "#{get_base_file_path}/Test_Detail.csv"
#   csv_file = File.open(file_path, "r:ISO-8859-1")
#   new_student_tests = []
#   data_imported = Omr::StudentTest.count > 0

#   return if data_imported && tests_to_process.empty?

#   CSV.foreach(csv_file, :headers => true).each do |csv_row|
#     # next if csv_row['Is_Delete'] == 'True'
#     test_id = csv_row['Test_ID'].to_i

#     next if data_imported && !tests_to_process.include?(test_id)

#     student_id = csv_row['Student_ID'].to_i
#     student_ans = csv_row['Student_ans_key']
#     score = csv_row['Student_Marks'].to_i
#     rank = csv_row['Rank'].to_i
#     child_test_id = csv_row['ChildTestID'].to_i

#     student_test = Omr::StudentTest.find_by(omr_student_id: student_id, omr_test_id: test_id)
#     if student_test.present?
#       next if student_test.score == score
#       student_test.destroy
#     end

#     new_student_tests << Omr::StudentTest.new(
#       omr_student_id: student_id,
#       omr_test_id: test_id,
#       student_ans: student_ans,
#       score: score,
#       rank: rank,
#       child_test_id: (test_id == child_test_id ? nil : child_test_id)
#     )

#     if new_student_tests.size >= 10000
#       Omr::StudentTest.import new_student_tests, validate: false
#       new_student_tests.clear
#     end
#   end

#   Omr::StudentTest.import new_student_tests, validate: false unless new_student_tests.empty?
# end
