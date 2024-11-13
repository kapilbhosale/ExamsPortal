class Omr::ImportService
  attr_reader :file_path, :branch
  attr_accessor :subjects, :tests_to_process

  # file_path = "/Users/kapilbhosale/Downloads/z_final.zip"
  # Omr::ImportService.new(file_path, 'latur').call
  def initialize(file_path, branch)
    @file_path = file_path
    @branch = branch
  end

  def call
    extract_zip(file_path)
    # destroy_omr_pr_data
    initialize_subjects

    # process_student_master
    Omr::ImportStudents.new(1, branch, "#{get_base_file_path}/Student_Master.csv").call
    # process_batch_master
    Omr::ImportBatches.new(1, branch, "#{get_base_file_path}/Batch_Master.csv").call

    # process_test_master
    tests_to_process = Omr::ImportTests.new(1, branch, "#{get_base_file_path}/Test_Master.csv").call

    # keeping old methods(3) for now
    process_combine_master
    process_ans_changes
    process_booklet_tests

    # process_batch_students
    Omr::ImportBatchStudents.new(1, branch, "#{get_base_file_path}/Batch_Student.csv").call
    # process_batch_tests
    Omr::ImportBatchTests.new(1, branch, "#{get_base_file_path}/Batch_Test_Detail.csv").call

    # process_student_tests
    Omr::ImportStudentTests.new(1, branch, "#{get_base_file_path}/Test_Detail.csv", tests_to_process).call

    # important calculations
    calculate_ranks_and_subject_scores(tests_to_process)

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


  def initialize_subjects
    file_path = "#{get_base_file_path}/Subject_Master.csv"
    csv_file = File.open(file_path, "r:ISO-8859-1")
    @subjects = {}
    CSV.foreach(csv_file, :headers => true).each do |csv_row|
      # next if csv_row['Is_Delete'] == 'True'
      @subjects[csv_row['Subject_ID'].to_i] = csv_row['Subject_Name']
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


  def process_combine_master
    if  Omr::Test.where(branch: branch).count > 0
      relevant_test_ids = Omr::Test.where(test_date: (DateTime.now - 1.month)..DateTime.now).pluck(:id)
    else
      relevant_test_ids = Omr::Test.pluck(:id)
    end

    file_path = "#{get_base_file_path}/Combine_Master.csv"
    csv_file = File.open(file_path, "r:ISO-8859-1")
    test_subject_data = {}
    CSV.foreach(csv_file, :headers => true).each do |csv_row|
      test_id = csv_row['Test_ID'].to_i
      next unless relevant_test_ids.include?(test_id)

      test_subject_data[test_id] ||= {}
      test_subject_data[test_id][@subjects[csv_row['Subject_ID'].to_i]] = {
        from: csv_row['C_From'].to_i,
        count: csv_row['No_Of_Question'].to_i
      }
    end

    test_subject_data.each do |test_id, subject_data|
      test = Omr::Test.find_by(id: test_id)
      next unless test

      test.data['subjects'] = subject_data
      test.save
    end
  end

  def process_booklet_tests
    file_path = "#{get_base_file_path}/bookletDetail.csv"
    csv_file = File.open(file_path, "r:ISO-8859-1")
    CSV.foreach(csv_file, :headers => true).each do |csv_row|
      # next if csv_row['Is_Delete'] == 'True'
      child_test_id = csv_row['ChildTestID'].to_i
      parent_test_id = csv_row['TestID'].to_i
      test = Omr::Test.find_by(id: child_test_id)
      test.update(parent_id: parent_test_id) if test.present?
    end
  end

  def calculate_ranks_and_subject_scores(tests_to_process)
    tests_to_process.each do |test_id|
      test = Omr::Test.find_by(id: test_id)
      if test
        test.calculate_rank
        puts "-"
        test.calculate_subject_scores
        puts "+"
      end
    end
  end

  def get_test_date(test_date)
    "#{test_date[0..3]}-#{test_date[4..5]}-#{test_date[6..7]}"
  end

  def get_base_file_path
    "#{Rails.root}/zip_data"
  end
end
