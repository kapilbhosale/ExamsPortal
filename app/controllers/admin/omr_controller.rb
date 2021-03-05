class Admin::OmrController < Admin::BaseController
  BATCH_IDS_11_12th = [41,42,43,44,46,47,60,89]

  def create
    @test_names_for_ranks = {}
    temp_file = params["omr_zip"].tempfile rescue nil
    extract_zip(temp_file)
    process_test_master
    process_student_test_data

    process_batch_test_detail
    process_batch_students
    make_absent_entries

    assign_ranks

    flash[:success] = "Imported data successfully"
    redirect_to admin_omr_index_path
  end

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

  def process_batch_test_detail
    @batch_test_details = {}
    file_path = "#{get_base_file_path}/Batch_Test_Detail.csv"
    csv_file = File.open(file_path, "r:ISO-8859-1")
    CSV.foreach(csv_file, :headers => true).each do |csv_row|
      batch_id = csv_row['Batch_ID'].to_i
      test_id = csv_row['Test_ID'].to_i

      @batch_test_details[batch_id] ||= []
      @batch_test_details[batch_id] << test_id
    end
  end

  def process_batch_students
    @student_batches = {}
    file_path = "#{get_base_file_path}/Batch_Student.csv"
    csv_file = File.open(file_path, "r:ISO-8859-1")
    CSV.foreach(csv_file, :headers => true).each do |csv_row|
      batch_id = csv_row['Batch_ID'].to_i
      student_id = csv_row['Student_ID'].to_i

      @student_batches[student_id] ||= []
      @student_batches[student_id] << batch_id
    end
  end

  def process_test_master
    @test_master_data = {}
    file_path = "#{get_base_file_path}/Test_Master.csv"
    csv_file = File.open(file_path, "r:ISO-8859-1")
    CSV.foreach(csv_file, :headers => true).each do |csv_row|
      test_id = csv_row['Test_ID'].to_i
      test_name = csv_row['Test_Name'].to_s.strip
      test_desc = csv_row['Descripation'].to_s.strip
      no_of_questions = csv_row['No_of_Questions'].to_i
      total_marks = csv_row['No_of_Marks'].to_i
      test_date = DateTime.parse(get_test_date(csv_row['Date_Of_Creation'].to_s.strip))
      @test_master_data[test_id] = {
        test_id: test_id,
        test_name: test_name,
        test_desc: test_desc,
        no_of_questions: no_of_questions,
        total_marks: total_marks,
        test_date: test_date
      }
    end
  end

  def process_student_test_data
    file_path = "#{get_base_file_path}/Test_Detail.csv"
    csv_file = File.open(file_path, "r:ISO-8859-1")
    @student_tests = {}
    @student_roll_numbers = {}
    CSV.foreach(csv_file, headers: true).each do |csv_row|
      student_id = csv_row['Student_ID'].to_i
      test_id = csv_row['Test_ID'].to_i
      @student_tests[student_id] ||= []
      @student_tests[student_id] << test_id
      roll_number = csv_row['Student_Roll_No'].to_s.strip
      student = Student.includes(:batches).where(batches: {id: BATCH_IDS_11_12th}).find_by(roll_number: roll_number)
      next if student.blank?

      @student_roll_numbers[student_id] = roll_number

      score = csv_row['Student_Marks'].to_i
      test = @test_master_data[test_id]
      @test_names_for_ranks["#{test[:test_date]}-#{test[:test_name]}"] ||= {
        exam_date: test[:test_date],
        exam_name: "#{test[:test_name]} (OMR)"
      }
      ProgressReport.find_or_create_by({
        data: {
          total: {
            score: score,
            total: test[:total_marks]
          }
        },
        percentage: (score/test[:total_marks].to_f) * 100,
        exam_date: test[:test_date],
        exam_name: "#{test[:test_name]} (OMR)",
        is_imported: true,
        student_id: student.id
      })
    end
  end

  def make_absent_entries
    # make absent tests entires here.
    student_not_appeared_tests = {}
    @student_tests.each do |student_id, test_ids|
      next if @student_batches[student_id].blank?

      batch_tests = []
      @student_batches[student_id].each do |batch_id|
        batch_tests += @batch_test_details[batch_id]
      end
      student_not_appeared_tests[student_id] = batch_tests - test_ids
    end

    student_not_appeared_tests.each do |student_id, test_ids|
      next if test_ids.blank?

      roll_number = @student_roll_numbers[student_id]
      student = Student.includes(:batches).where(batches: {id: BATCH_IDS_11_12th}).find_by(roll_number: roll_number)
      next if student.blank?

      test_ids.each do |test_id|
        test = @test_master_data[test_id]
        @test_names_for_ranks["#{test[:test_date]}-#{test[:test_name]}"] ||= {
          exam_date: test[:test_date],
          exam_name: "#{test[:test_name]} (OMR)"
        }
        ProgressReport.find_or_create_by({
          data: {
            total: {
              score: '-',
              total: test[:total_marks]
            }
          },
          percentage: nil,
          exam_date: test[:test_date],
          exam_name: "#{test[:test_name]} (OMR)",
          is_imported: true,
          student_id: student.id
        })
      end
    end
  end

  def assign_ranks
    @test_names_for_ranks.values.each do |vals|
      rank = 1
      pr_data = ProgressReport.where(exam_date: vals[:exam_date]).where(exam_name: vals[:exam_name]).group_by(&:percentage)
      pr_data.sort_by { |k, v| -k }.to_h.each do |_, prs|
        ProgressReport.where(id: prs.collect(&:id)).update_all(rank: rank)
        rank += 1
      end
    end
  end

  def get_base_file_path
    "#{Rails.root}/zip_data"
  end

  def get_test_date(test_date)
    dt = test_date.split(' ').first
    dts = dt.split('/')
    "#{dts[2]}-#{dts[0]}-#{dts[1]}"
  end
end
