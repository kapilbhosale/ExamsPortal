class Admin::OmrController < Admin::BaseController
  before_action :check_permissions

  def index
    @branches = current_org.data['branches']
  end

  def students_list
    @branches = current_org.data['branches']
    @search = Omr::Student.where(org: current_org)
    @branch = params[:branch]
    @search = @search.where(branch: @branch) if @branch.present?
    @search = @search.search(search_params)
    @students = @search.result.order(created_at: :desc)
    @students = @students.page(params[:page]).per(params[:limit] || ITEMS_PER_PAGE)
  end

  def tests_list
    @branches = current_org.data['branches']
    @branch = params[:branch]
    @search = Omr::Test.where(org: current_org).where(parent_id: nil)
    @search = @search.where(branch: @branch) if @branch.present?
    @search = @search.search(test_search_params)
    @tests = @search.result.order(created_at: :desc)
    @tests = @tests.page(params[:page]).per(params[:limit] || ITEMS_PER_PAGE)
  end

  def test_report_batch_selection
    @test = Omr::Test.find(params[:test_id])
    @batches = @test.omr_batches
  end

  def test_report_print
    @test = Omr::Test.find(params[:test_id])
    selected_batches = Omr::Batch.find(params[:batches])
    # if (params["commit"] == "detailed_report")
      exclude_absents = params[:exclude_absents].present?
      report_type = params[:report_type]
      report_format = params[:report_format]
      @report_data = Omr::TestReportService.new(@test, selected_batches.pluck(:id), exclude_absents, report_type).call
    # else
    #   Omr::TestSummaryReportService.new(@test, @selected_batches.pluck(:id)).call
    # end
  end

  def progress_report
    @student = Omr::Student.find(params[:student_id])
    @attempted_tests = @student.omr_student_tests.index_by(&:omr_test_id)

    @all_tests, exam_names, percent_score, colors, toppers = [], [], [], [], []
    @subjects = []
    average_scores = []
    @subject_scores_per_test = {}

    @student.omr_batches.each do |batch|
      batch.omr_tests.includes(:parent_test).order(id: :desc).each do |test|
        next if test.parent_test.present?

        @all_tests << {id: test.id, name: test.test_name, qcount: test.no_of_questions, total_marks: test.total_marks, date: test.test_date.strftime("%d-%b-%Y")}
        exam_names << "Test-#{test.id}"
        student_test = @attempted_tests[test.id]
        toppers << test.toppers['ALL'].to_i * 100 / test.total_marks
        @subject_scores_per_test[test.id] = {}
        @avg_per_test = {}

        if student_test.present?
          percent = student_test.score.to_i * 100 / test.total_marks
          average_scores << percent
          percent_score << percent
          colors << get_color(percent)
          @subject_scores_per_test[test.id]['rank'] = student_test.rank

          student_test.data.each do |subject, score_data|
            next if subject == 'single_subject'

            @subjects << subject if @subjects.exclude?(subject)
            @subject_scores_per_test[test.id][subject] = score_data['score']
            @avg_per_test[subject] ||= []
            @avg_per_test[subject] << score_data['score']
          end

        else
          percent_score << 0
          colors << 'gray'
        end
      end
    end

    @graph_data = {
      exam_names: exam_names,
      percent_score: percent_score,
      colors: colors,
      toppers: toppers,
      average: average_scores.present? (average_scores.sum / average_scores.size) : 0
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
    temp_file = params["omr_zip"].tempfile rescue nil

    if temp_file.present?
      OmrImportWorker.perform_async(temp_file.path, params[:branch])
      flash[:success] = "Importing data..."
    else
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
