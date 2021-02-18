class Admin::OmrController < Admin::BaseController
  def create
    temp_file = params["omr_zip"].tempfile rescue nil
    extract_zip(temp_file)
    process_test_master
    prcess_student_test_data
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

  def prcess_student_test_data
    file_path = "#{get_base_file_path}/Test_Detail.csv"
    csv_file = File.open(file_path, "r:ISO-8859-1")
    CSV.foreach(csv_file, headers: true).each do |csv_row|
      test_id = csv_row['Test_ID'].to_i
      roll_number = csv_row['Student_Roll_No'].to_s.strip
      student = Student.find_by(roll_number: roll_number)
      next if student.blank?

      score = csv_row['Student_Marks'].to_i
      test = @test_master_data[test_id]
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

  def get_base_file_path
    "#{Rails.root}/zip_data"
  end

  def get_test_date(test_date)
    dt = test_date.split(' ').first
    dts = dt.split('/')
    "#{dts[2]}-#{dts[0]}-#{dts[1]}"
  end
end
