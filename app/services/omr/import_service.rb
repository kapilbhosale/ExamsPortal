class Omr::ImportService
  attr_reader :file_path, :branch

  # file_path = "/Users/kapilbhosale/Downloads/z.zip"
  # Omr::ImportService.new(file_path, 'latur').call
  def initialize(file_path, branch)
    @file_path = file_path
    @branch = branch
  end

  def call
    # extract_zip(file_path)
    # destroy_omr_pr_data
    process_student_master
    process_batch_master
    process_test_master

    process_batch_students
    process_batch_tests

    process_student_tests
    process_ans_changes

  rescue StandardError => ex
    Rails.logger.error ex.message
    return {status: false, message: ex.message}
  end

  private

  def extract_zip(temp_file)
    zip_name = "zip_#{Time.now.to_i}"
    zip_file_path = "#{Rails.root}/zip_data/#{zip_name}.zip"
    FileUtils.rm_rf(Dir.glob("#{Rails.root}/zip_data/*.csv"))
    FileUtils.rm_rf(Dir.glob("#{Rails.root}/zip_data/*.zip"))

    FileUtils.mv temp_file, zip_file_path

    Zip::ZipFile.open(zip_file_path) do |zip_file|
      zip_file.each do |f|
        f_path=File.join("#{Rails.root}/zip_data/", f.name)
        FileUtils.mkdir_p(File.dirname(f_path))
        zip_file.extract(f, f_path) {true}
      end
    end
  end

  def destroy_omr_pr_data
    if ProgressReport.column_names.include?('org_id')
      ProgressReport.where(org_id: 1, omr: true).delete_all
    end
  end

  def process_student_master
    file_path = "#{get_base_file_path}/Student_Master.csv"
    csv_file = File.open(file_path, "r:ISO-8859-1")
    CSV.foreach(csv_file, :headers => true).each do |csv_row|
      putc "."
      omr_student = Omr::Student.find_by(id: csv_row['Student_ID'])
      unless omr_student.present?
        omr_student = Omr::Student.new
        omr_student.org_id = 1
        omr_student.id = csv_row['Student_ID'].to_i
        omr_student.roll_number = csv_row['Student_Roll_No']
        omr_student.name = csv_row['FName']
        omr_student.parent_contact = csv_row['Parent_Contact'].to_s.strip
        omr_student.student_contact = csv_row['Contact'].to_s.strip
        omr_student.branch = branch
        omr_student.save
      end

      if omr_student.student_id.blank?
        student = Student.find_by(roll_number: csv_row['Student_Roll_No'], org_id: 1, parent_mobile: omr_student.parent_contact)
        if student.present?
          omr_student.student_id = student.id
          omr_student.save
        end
      end
    end
  end

  def process_batch_master
    file_path = "#{get_base_file_path}/Batch_Master.csv"
    csv_file = File.open(file_path, "r:ISO-8859-1")
    CSV.foreach(csv_file, :headers => true).each do |csv_row|
      batch = Omr::Batch.find_by(id: csv_row['Batch_ID'])
      unless batch.present?
        Omr::Batch.create(
          id: csv_row['Batch_ID'].to_i,
          name: csv_row['Batch_Name'],
          org_id: 1,
          db_modified_date: csv_row['Date_Of_Modification'],
          branch: branch
        )
      end
    end
  end

  def process_batch_students
    file_path = "#{get_base_file_path}/Batch_Student.csv"
    csv_file = File.open(file_path, "r:ISO-8859-1")
    CSV.foreach(csv_file, :headers => true).each do |csv_row|
      Omr::StudentBatch.find_or_create_by(
        omr_student_id: csv_row['Student_ID'].to_i,
        omr_batch_id: csv_row['Batch_ID'].to_i
      )
    end
  end

  def process_batch_tests
    file_path = "#{get_base_file_path}/Batch_Test_Detail.csv"
    csv_file = File.open(file_path, "r:ISO-8859-1")
    CSV.foreach(csv_file, :headers => true).each do |csv_row|
      Omr::BatchTest.find_or_create_by(
        omr_batch_id: csv_row['Batch_ID'].to_i,
        omr_test_id: csv_row['Test_ID'].to_i
      )
    end
  end

  def process_ans_changes
    file_path = "#{get_base_file_path}/Test_Option.csv"
    csv_file = File.open(file_path, "r:ISO-8859-1")
    CSV.foreach(csv_file, :headers => true).each do |csv_row|
      test = Omr::Test.find_by(id: csv_row['Test_ID'].to_i)
      next if test.blank?

      ans_data = test.answer_key[csv_row['Question_Number']]
      next if ans_data.blank?

      unless ans_data['ans'].include?(csv_row['Opt'])
        test.answer_key[csv_row['Question_Number']]['ans'] << csv_row['Opt']
      end
      test.save
    end
  end

  def process_test_master
    file_path = "#{get_base_file_path}/Test_Master.csv"
    csv_file = File.open(file_path, "r:ISO-8859-1")
    @tests_counts = 0
    CSV.foreach(csv_file, :headers => true).each do |csv_row|
      @tests_counts += 1
      test_id = csv_row['Test_ID'].to_i
      test_name = csv_row['Test_Name'].to_s.strip
      test_desc = csv_row['Descripation'].to_s.strip
      no_of_questions = csv_row['No_of_Questions'].to_i
      total_marks = csv_row['No_of_Marks'].to_i
      test_date = DateTime.parse(get_test_date(csv_row['Test_Date'].to_s.strip))
      ans_key = csv_row['Answer_Key'].to_s.strip.split("|")
      positive_marks = csv_row['Positive_Mark_By_Question'].to_s.strip.split()
      negative_marks = csv_row['Negative_Mark_By_Question'].to_s.strip.split()
      is_booket = csv_row['isBooklet'] == 'True'
      db_modified_date = csv_row['Date_Of_Modification']

      test = Omr::Test.find_by(id: test_id)
      if test.present?
        next if test.db_modified_date == db_modified_date
        test.update!(
          test_name: test_name,
          description: test_desc,
          no_of_questions: no_of_questions,
          total_marks: total_marks,
          test_date: test_date,
          is_booket: is_booket,
          db_modified_date: db_modified_date,
          branch: branch
        )
      else
        test = Omr::Test.create!(
          org_id: 1,
          id: test_id,
          test_name: test_name,
          description: test_desc,
          no_of_questions: no_of_questions,
          total_marks: total_marks,
          test_date: test_date,
          is_booket: is_booket,
          db_modified_date: db_modified_date,
          branch: branch
        )
      end

      unless is_booket
        answer_key = {}
        ans_key.each_with_index do |ans, index|
          answer_key[index + 1] = { ans: [ans], pm: positive_marks[index].to_i, nm: negative_marks[index].to_i }
        end
        test.update(answer_key: answer_key)
      end
    end
  end

  def process_student_tests
    file_path = "#{get_base_file_path}/Test_Detail.csv"
    csv_file = File.open(file_path, "r:ISO-8859-1")
    CSV.foreach(csv_file, :headers => true).each do |csv_row|
      test_id = csv_row['Test_ID'].to_i
      student_id = csv_row['Student_ID'].to_i
      student_ans = csv_row['Student_ans_key']
      score = csv_row['Student_Marks'].to_i
      rank = csv_row['Rank'].to_i
      child_test_id = csv_row['ChildTestID'].to_i

      student_test = Omr::StudentTest.find_by(omr_student_id: student_id, omr_test_id: test_id)
      next if student_test.present? && student_test.score == score

      Omr::StudentTest.create(
        omr_student_id: student_id,
        omr_test_id: test_id,
        student_ans: student_ans,
        score: score,
        rank: rank,
        child_test_id: (test_id == child_test_id ? nil : child_test_id)
      )
    end
  end

  def validate_request
    raise StandardError, 'some errors' unless exam_exists?
  end

  def get_test_date(test_date)
    "#{test_date[0..3]}-#{test_date[4..5]}-#{test_date[6..7]}"
  end

  def exam_exists?
    false
  end

  def get_base_file_path
    "#{Rails.root}/zip_data"
  end
end
