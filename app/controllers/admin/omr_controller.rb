class Admin::OmrController < Admin::BaseController
  before_action :check_permissions

  def create
    @test_names_for_ranks = {}
    temp_file = params["omr_zip"].tempfile rescue nil
    extract_zip(temp_file)

    destroy_omr_pr_data

    process_student_master
    process_test_master
    process_student_test_data

    process_batch_test_detail

    process_batch_students
    make_absent_entries

    assign_ranks

    REDIS_CACHE.set("omr-import-info-time", DateTime.now.strftime("%d-%B-%Y %I:%M%p"))
    REDIS_CACHE.set("omr-import-info-total_tests", @tests_counts)
    REDIS_CACHE.set("omr-import-info-last_test_name", @test_name)
    REDIS_CACHE.set("omr-import-info-last_test_desc", @test_desc)
    REDIS_CACHE.set("omr-import-info-last_test_date", @test_date.strftime("%d-%B-%Y %I:%M%p"))

    flash[:success] = "Imported data successfully"
    redirect_to admin_omr_index_path
  end

  def destroy_omr_pr_data
    if ProgressReport.column_names.include?('org_id')
      ProgressReport.where(org_id: current_org.id, omr: true).delete_all
    end
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

  def process_student_master
    @student_master_lookup = {}
    file_path = "#{get_base_file_path}/Student_Master.csv"
    csv_file = File.open(file_path, "r:ISO-8859-1")
    CSV.foreach(csv_file, :headers => true).each do |csv_row|
      student_id = csv_row['Student_ID'].to_i
      # contact = csv_row['Contact'].to_s.strip
      parent_contact = csv_row['Parent_Contact'].to_s.strip
      @student_master_lookup[student_id] = parent_contact
    end
  end

  def process_test_master
    @test_master_data = {}
    file_path = "#{get_base_file_path}/Test_Master.csv"
    csv_file = File.open(file_path, "r:ISO-8859-1")
    @tests_counts = 0
    CSV.foreach(csv_file, :headers => true).each do |csv_row|
      @tests_counts += 1
      test_id = csv_row['Test_ID'].to_i
      @test_name = csv_row['Test_Name'].to_s.strip
      @test_desc = csv_row['Descripation'].to_s.strip
      no_of_questions = csv_row['No_of_Questions'].to_i
      total_marks = csv_row['No_of_Marks'].to_i
      @test_date = DateTime.parse(get_test_date(csv_row['Test_Date'].to_s.strip))
      @test_master_data[test_id] = {
        test_id: test_id,
        test_name: @test_name,
        test_desc: @test_desc,
        no_of_questions: no_of_questions,
        total_marks: total_marks,
        test_date: @test_date
      }
    end
  end

  def process_student_test_data
    file_path = "#{get_base_file_path}/Test_Detail.csv"
    csv_file = File.open(file_path, "r:ISO-8859-1")
    @student_tests = {}
    @student_roll_numbers = {}
    create_pr_params = []
    student_counts_by_rn = Student.where(org_id: current_org.id).group(:roll_number).count
    students_by_rn = Student.where(org_id: current_org.id).index_by(&:roll_number)
    @test_names_for_ranks = {}
    CSV.foreach(csv_file, headers: true).each do |csv_row|
      student_id = csv_row['Student_ID'].to_i
      test_id = csv_row['Test_ID'].to_i
      @student_tests[student_id] ||= []
      @student_tests[student_id] << test_id
      roll_number = csv_row['Student_Roll_No'].to_s.strip

      if student_counts_by_rn[roll_number.to_i].to_i > 1
        student = Student.find_by(
          org_id: current_org.id,
          roll_number: roll_number,
          parent_mobile: @student_master_lookup[student_id]
        )
      else
        student = students_by_rn[roll_number.to_i]
      end

      next if student.blank?

      @student_roll_numbers[student_id] = roll_number

      score = csv_row['Student_Marks'].to_i
      test = @test_master_data[test_id]

      next if test.blank?

      @test_names_for_ranks["#{test[:test_date]}-#{test[:test_name]}"] ||= {
        exam_date: test[:test_date],
        exam_name: "#{test[:test_name]} (OMR)"
      }
      # ["data", "exam_date", "exam_name", "is_imported", "omr", "percentage", "org_id", "student_id"]
      create_pr_params << {
        data: {
          total: {
            score: score,
            total: test[:total_marks]
          }
        }.to_json,
        exam_date: test[:test_date],
        exam_name: "#{test[:test_name]} (OMR)",
        is_imported: true,
        omr: true,
        percentage: (score/test[:total_marks].to_f) * 100,
        org_id: current_org.id,
        student_id: student.id,
      }

      if create_pr_params.size >= 1000
        puts "\n\n\n\n\n ===================> BATCH INSERT"
        ProgressReport.import create_pr_params, validate: false
        create_pr_params = []
      end
    end

    if create_pr_params.size >= 1
      ProgressReport.import create_pr_params, validate: false
      create_pr_params = []
    end
  end

  def make_absent_entries
    # make absent tests entires here.
    student_not_appeared_tests = {}
    @student_tests.each do |student_id, test_ids|
      next if @student_batches[student_id].blank?

      batch_tests = []
      @student_batches[student_id].each do |batch_id|
        batch_tests += @batch_test_details[batch_id] if @batch_test_details[batch_id].present?
      end
      student_not_appeared_tests[student_id] = batch_tests - test_ids
    end

    create_pr_params = []
    student_counts_by_rn = Student.where(org_id: current_org.id).group(:roll_number).count
    students_by_rn = Student.where(org_id: current_org.id).index_by(&:roll_number)

    student_not_appeared_tests.each do |student_id, test_ids|
      next if test_ids.blank?

      roll_number = @student_roll_numbers[student_id].to_s.strip.to_i

      if student_counts_by_rn[roll_number].to_i > 1
        student = Student.find_by(
          org_id: current_org.id,
          roll_number: roll_number,
          parent_mobile: @student_master_lookup[student_id]
        )
      else
        student = students_by_rn[roll_number]
      end

      next if student.blank?

      test_ids.each do |test_id|
        test = @test_master_data[test_id]
        next if test.blank?

        @test_names_for_ranks["#{test[:test_date]}-#{test[:test_name]}"] ||= {
          exam_date: test[:test_date],
          exam_name: "#{test[:test_name]} (OMR)"
        }
        create_pr_params << {
          data: {
            total: {
              score: '-',
              total: test[:total_marks]
            }
          }.to_json,
          exam_date: test[:test_date],
          exam_name: "#{test[:test_name]} (OMR)",
          is_imported: true,
          omr: true,
          percentage: nil,
          org_id: current_org.id,
          student_id: student.id
        }

        if create_pr_params.size >= 1000
          puts "\n\n\n\n\n ===================> BATCH INSERT"
          ProgressReport.import create_pr_params, validate: false
          create_pr_params = []
        end

      end
    end
  end

  def assign_ranks
    @test_names_for_ranks.values.each do |vals|
      rank = 1
      pr_data = ProgressReport.where.not(percentage: nil).where(exam_date: vals[:exam_date]).where(exam_name: vals[:exam_name]).group_by(&:percentage)
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
    "#{test_date[0..3]}-#{test_date[4..5]}-#{test_date[6..7]}"
  end

  def pr_columns
    ["data", "exam_date", "exam_name", "is_imported", "omr", "percentage", "org_id", "student_id"]
  end

  def check_permissions
    redirect_to '/404' unless current_admin.can_manage(:omr)
  end
end
