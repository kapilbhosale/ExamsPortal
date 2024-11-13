# file_path = '/Users/kapilbhosale/Downloads/test_zip/Test_Master.csv'
# Omr::ImportTests.new(1, 'latur', file_path).call
class Omr::ImportTests
  attr_reader :org_id, :branch, :file_path

  def initialize(org_id, branch, file_path)
    @org_id = org_id
    @branch = branch
    @file_path = file_path
  end

  def call
    csv_file = File.open(file_path, "r:ISO-8859-1")
    tests_to_insert = []
    tests_to_process = []

    begin
      CSV.foreach(csv_file, :headers => true).each do |csv_row|
        test_id = csv_row['Test_ID'].to_i
        test_name = csv_row['Test_Name'].to_s.strip
        test_desc = csv_row['Descripation'].to_s.strip
        no_of_questions = csv_row['No_of_Questions'].to_i
        total_marks = csv_row['No_of_Marks'].to_i
        test_date = DateTime.parse(get_test_date(csv_row['Test_Date'].to_s.strip))
        ans_key = csv_row['Answer_Key'].to_s.strip.split("|")
        positive_marks = csv_row['Positive_Mark_By_Question'].to_s.strip.split()
        negative_marks = csv_row['Negative_Mark_By_Question'].to_s.strip.split()
        is_booklet = csv_row['isBooklet'] == 'True'
        is_combine = csv_row['Is_Combine'] == 'True'
        db_modified_date = csv_row['Date_Of_Modification']

        test = Omr::Test.find_by(old_id: test_id)
        if test.present?
          next if test.db_modified_date == db_modified_date
          test.update!(
            test_name: test_name,
            description: test_desc,
            no_of_questions: no_of_questions,
            total_marks: total_marks,
            test_date: test_date,
            is_booklet: is_booklet,
            is_combine: is_combine,
            db_modified_date: db_modified_date,
          )
        else
          test = Omr::Test.create!({
            org_id: 1,
            test_name: test_name,
            description: test_desc,
            no_of_questions: no_of_questions,
            total_marks: total_marks,
            test_date: test_date,
            is_booklet: is_booklet,
            is_combine: is_combine,
            db_modified_date: db_modified_date,
            branch: branch,
            old_id: test_id
          })
        end

        tests_to_process << test.id
        unless is_booklet
          answer_key = {}
          ans_key.each_with_index do |ans, index|
            answer_key[index + 1] = {
              ans: [ans],
              pm: positive_marks[index].to_i,
              nm: negative_marks[index].to_i,
              is_num: !['A', 'B', 'C', 'D', 'E', 'M'].include?(ans)
            }
          end
          test.update(answer_key: answer_key)
        end
      end
    ensure
      csv_file.close
    end

    return tests_to_process
  end

  private
    # def insert_tests(tests)
    #   puts "Inserting #{tests.size} tests"
    #   Omr::Test.import(
    #     tests,
    #     on_duplicate_key_ignore: true
    #   )
    # end

    def get_test_date(test_date)
      "#{test_date[0..3]}-#{test_date[4..5]}-#{test_date[6..7]}"
    end
end


# def process_test_master
#   file_path = "#{get_base_file_path}/Test_Master.csv"
#   csv_file = File.open(file_path, "r:ISO-8859-1")
#   @tests_counts = 0
#   CSV.foreach(csv_file, :headers => true).each do |csv_row|
#     # next if csv_row['Is_Delete'] == 'True'
#     @tests_counts += 1
#     test_id = csv_row['Test_ID'].to_i
#     test_name = csv_row['Test_Name'].to_s.strip
#     test_desc = csv_row['Descripation'].to_s.strip
#     no_of_questions = csv_row['No_of_Questions'].to_i
#     total_marks = csv_row['No_of_Marks'].to_i
#     test_date = DateTime.parse(get_test_date(csv_row['Test_Date'].to_s.strip))
#     ans_key = csv_row['Answer_Key'].to_s.strip.split("|")
#     positive_marks = csv_row['Positive_Mark_By_Question'].to_s.strip.split()
#     negative_marks = csv_row['Negative_Mark_By_Question'].to_s.strip.split()
#     is_booklet = csv_row['isBooklet'] == 'True'
#     is_combine = csv_row['Is_Combine'] == 'True'
#     db_modified_date = csv_row['Date_Of_Modification']


#     test = Omr::Test.find_by(id: test_id)
#     if test.present?
#       next if test.db_modified_date == db_modified_date
#       test.update!(
#         test_name: test_name,
#         description: test_desc,
#         no_of_questions: no_of_questions,
#         total_marks: total_marks,
#         test_date: test_date,
#         is_booklet: is_booklet,
#         is_combine: is_combine,
#         db_modified_date: db_modified_date,
#         branch: branch
#       )
#     else
#       test = Omr::Test.create!(
#         org_id: 1,
#         id: test_id,
#         test_name: test_name,
#         description: test_desc,
#         no_of_questions: no_of_questions,
#         total_marks: total_marks,
#         test_date: test_date,
#         is_booklet: is_booklet,
#         is_combine: is_combine,
#         db_modified_date: db_modified_date,
#         branch: branch
#       )
#     end

#     tests_to_process << test.id
#     unless is_booklet
#       answer_key = {}
#       ans_key.each_with_index do |ans, index|
#         answer_key[index + 1] = {
#           ans: [ans],
#           pm: positive_marks[index].to_i,
#           nm: negative_marks[index].to_i,
#           is_num: !['A', 'B', 'C', 'D', 'E', 'M'].include?(ans)
#         }
#       end
#       test.update(answer_key: answer_key)
#     end
#   end
# end