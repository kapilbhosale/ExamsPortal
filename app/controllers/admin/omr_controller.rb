class Admin::OmrController < Admin::BaseController
  before_action :check_permissions

  def index
    @branches = current_org.data['omr_branches'][current_admin.id.to_s]
    REDIS_CACHE.del("omr-import-info-error")
  end

  def students_list
    @branches = current_org.data['omr_branches'][current_admin.id.to_s]
    @search = Omr::Student.where(org: current_org)
    @branch = params[:branch] || @branches.first
    @search = @search.where(branch: @branch) if @branch.present?
    @search = @search.search(search_params)
    @students = @search.result.order(created_at: :desc)
    @students = @students.page(params[:page]).per(params[:limit] || ITEMS_PER_PAGE)
  end

  def tests_list
    @branches = current_org.data['omr_branches'][current_admin.id.to_s]
    @branch = params[:branch] || @branches.first
    @search = Omr::Test.where(org: current_org).where(parent_id: nil)
    @search = @search.where(branch: @branch) if @branch.present?
    @count = @search.count
    @search = @search.search(test_search_params)
    @tests = @search.result.order(created_at: :desc)
    @tests = @tests.page(params[:page]).per(params[:limit] || ITEMS_PER_PAGE)
  end

  def test_report_batch_selection
    @test = Omr::Test.find(params[:test_id])
    @batches = @test.omr_batches
  end

  # deepak+kapil report
  def test_report_print
    @test = Omr::Test.find(params[:test_id])
    @selected_batches = Omr::Batch.find(params[:batches])
    @subjects = @test.data['subjects'].keys.map do |sub|
      Omr::Test.get_subject_code(sub)
    end
    @sub_max_marks = @test.get_subject_max_marks

    include_absents = params[:include_absents].present?
    report_type = params[:report_type]
    report_format = params[:report_format]
    @report_data = Omr::TestReportService.new(@test, @selected_batches.pluck(:id), include_absents, report_type).call
  end

  def progress_report_dates
    @student = Omr::Student.find(params[:student_id])
    appeared_test_ids = Omr::StudentTest.where(omr_student_id: @student.id).ids
    batch_test_ids = Omr::BatchTest.where(omr_batch_id: @student.omr_batches.pluck(:id)).pluck(:omr_test_id)
    @tests = Omr::Test.where(id: appeared_test_ids + batch_test_ids).order(test_date: :desc)
  end

  def progress_report
    @student = Omr::Student.find(params[:student_id])
    @online_student = Student.find_by(org_id: current_org.id, roll_number: @student.roll_number)
    from_date = params[:from_date]
    to_date = params[:to_date]
    test_order = params[:test_order] == 'descending' ? :desc : :asc

    selected_test_ids = params[:selected_tests]

    if selected_test_ids.blank?
      flash[:error] = "No tests selected. Please select at least one test."
      redirect_to progress_report_dates_admin_omr_index_path(student_id: @student.id) and return
    end

    @present_count = 0
    student_batches = @student.omr_batches.pluck(:name)

    @all_tests, exam_names, percent_score, colors, toppers = [], [], [], [], []
    @subjects = []
    average_scores = []
    @subject_scores_per_test = {}

    # .where(omr_batches: { id: @student.omr_batches.pluck(:id) })
    omr_tests = Omr::Test.joins(:omr_batches)
                      .where(id: selected_test_ids)
                      .where('omr_tests.test_date <= ?', to_date)
                      .includes(:parent_test, :omr_batches)
                      .order(test_date: test_order)

    omr_tests = omr_tests.where('omr_tests.test_date >= ?', from_date) if from_date.present?

    @attempted_tests = @student.omr_student_tests
                          .includes(:omr_test)
                          .where(omr_tests: { id: omr_tests.ids })
                          .index_by(&:omr_test_id)


    sr_number = test_order == :asc ? 1 : omr_tests.where(parent_id: nil).size
    omr_tests.each_with_index do |test, index|
      next if test.parent_test.present?

      @all_tests << {
        sr_number: sr_number,
        id: test.id,
        name: test.test_name,
        desc: test.description,
        qcount: test.no_of_questions,
        total_marks: test.total_marks,
        date: test.test_date.strftime("%d-%b-%y")
      }
      exam_names << sr_number
      student_test = @attempted_tests[test.id]
      topper_percentage = test.toppers['ALL'].to_i * 100 / test.total_marks
      toppers << topper_percentage
      @subject_scores_per_test[test.id] = {}
      @avg_per_test = {}
      percentile = 0

      if student_test.present?
        percent = student_test.score.to_i * 100 / test.total_marks
        average_scores << percent
        percent_score << percent
        colors << get_color(percent)
        percentile = percent * 100 / topper_percentage.to_f
        @subject_scores_per_test[test.id]['rank'] = student_test.rank
        @subject_scores_per_test[test.id]['percentage'] = (student_test.score.to_i * 100 / test.total_marks.to_f).round(2)
        @subject_scores_per_test[test.id]['percentile'] = percentile.round(2)
        accuracies = []

        student_test.data.each do |subject, score_data|
          next if subject == 'single_subject'
          sub_code = Omr::Test.get_subject_code(subject)

          @subjects << sub_code if @subjects.exclude?(sub_code)
          @subject_scores_per_test[test.id][sub_code] ||= {}
          @subject_scores_per_test[test.id][sub_code]['score'] = score_data['score']
          @subject_scores_per_test[test.id][sub_code]['A'] = score_data['correct_count'] + score_data['wrong_count']
          @subject_scores_per_test[test.id][sub_code]['C'] = score_data['correct_count']
          @subject_scores_per_test[test.id][sub_code]['W'] = score_data['wrong_count']
          @subject_scores_per_test[test.id][sub_code]['S'] = score_data['skip_count']
          @avg_per_test[sub_code] ||= []
          @avg_per_test[sub_code] << score_data['score']
          accuracies << (score_data['correct_count'] * 100 / (score_data['correct_count'] + score_data['wrong_count']).to_f).round(2)
        end
        @subject_scores_per_test[test.id]['accuracy'] = (accuracies.sum / accuracies.size.to_f).round(2)
        @present_count += 1
      else
        percent_score << 0
        colors << 'gray'
      end

      sr_number = test_order == :asc ? sr_number + 1 : sr_number - 1
    end

    @graph_data = {
      exam_names: exam_names,
      percent_score: percent_score,
      colors: colors,
      toppers: toppers,
      average: average_scores.present? ? (average_scores.sum / average_scores.size) : 0
    }

    @student_summary_per_subject = Omr::StudentTest.get_student_summary(@student.id)

    respond_to do |format|
      format.html do
      end
      format.pdf do
        render pdf: "Student-#{@student.roll_number}.pdf",
               footer: { font_size: 9, left: DateTime.now.strftime("%d-%B-%Y %I:%M%p"), right: 'Page [page] of [topage]' }
      end
    end
  end


  def create
    temp_file = params["omr_zip"]&.tempfile
    unless temp_file
      Rails.logger.error "File upload failed or missing."
      flash[:error] = "No file uploaded. Please try again."
      redirect_to admin_omr_index_path and return
    end

    # Cleanup old files
    FileUtils.rm_rf(Dir.glob("#{Rails.root}/zip_data/*.csv"))
    FileUtils.rm_rf(Dir.glob("#{Rails.root}/zip_data/*.zip"))

    begin
      permanent_file_path = Rails.root.join("zip_data", "upload_#{Time.now.to_i}.zip")
      FileUtils.mv(temp_file.path, permanent_file_path)

      # Wait for file to be fully written (max 5 seconds)
      wait_time = 5
      wait_interval = 1
      attempts = 3

      file_ready = false
      attempts.times do
        sleep wait_interval
        if File.exist?(permanent_file_path) && File.size(permanent_file_path) > 0
          file_ready = true
          break
        end
      end

      unless file_ready
        raise "File not copied successfully after #{wait_time} seconds"
      end

      Rails.logger.info "File successfully copied. Size: #{File.size(permanent_file_path)} bytes"

      unless params[:branch].present?
        Rails.logger.error "Branch parameter is missing."
        flash[:error] = "Branch information is required."
        redirect_to admin_omr_index_path and return
      end

      Rails.logger.info "Enqueuing OmrImportWorker with file: #{permanent_file_path} and branch: #{params[:branch]}"
      result = OmrImportWorker.perform_async(permanent_file_path, params[:branch])
      Rails.logger.info "Job enqueued with ID: #{result}"

      REDIS_CACHE.set("omr-import-info-status", "in-progress")
      flash[:success] = "Importing data.......++"
    rescue StandardError => e
      Rails.logger.error "Error processing OMR import: #{e.message}"
      flash[:error] = "Failed to import data. Please try again."
    end

    redirect_to admin_omr_index_path
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

  def check_permissions
    redirect_to '/404' unless current_admin.can_manage(:omr)
  end

  def search_params
    return {} if params[:q].blank?

    search_term = params[:q][:name_and_roll_number]&.strip

    # to check if input is number or string
    if search_term.to_i.to_s == search_term
      return { roll_number_eq: search_term } if search_term.length <= 7
      return { parent_contact_cont: search_term }
    end

    { name_cont: search_term }
  end

  def test_search_params
    return {} if params[:q].blank?

    { test_name_cont: params[:q][:test_name] }
  end

  def get_color(percent)
    case percent
    when 0..19
      "#ff0000"
    when 20..39
      "#ca3433"
    when 40..59
      "#FF8000"
    when 60..69
      "#77fc7c"
    when 70..79
      "#4af950"
    when 80..89
      "#29fb30"
    else
      "#00ff09"
    end
  end
end
