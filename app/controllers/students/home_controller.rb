class Students::HomeController < Students::BaseController
  before_action :authenticate_student!, except: [:index, :auto_auth]
  skip_before_action :verify_authenticity_token, only: [:sync, :submit]
  layout 'student_exam_layout', only: [:exam]

  def index
    @subdomain = request.subdomain
    @org = Org.find_by(subdomain: @subdomain)
    student = Student.find_by(roll_number: params[:r], parent_mobile: params[:m])
    sign_in_and_redirect(student) if student.present?
  end

  def auto_auth
    student = Student.find_by(roll_number: params[:r], parent_mobile: params[:m])
    if student.present?
      sign_in_and_redirect(student)
    else
      redirect_to "/student/sign_in"
    end
  end

  def tests
    batch_ids = current_student.batches.map(&:id)
    exam_ids = ExamBatch.where(batch_id: batch_ids).joins(:exam).map(&:exam_id)
    @new_exams = Exam
      .where(id: exam_ids)
      .where('show_exam_at > ?', Time.current - 1.days)
      .where('show_exam_at <= ?', Time.current + 2.days)
      .order(created_at: :desc)
    @previous_exams = Exam
      .where(id: exam_ids)
      .where('show_exam_at <= ?', Time.current - 1.days )
    if current_org.rcc?
      @previous_exams = @previous_exams.where('show_exam_at > ?', Time.current - 7.days )
    end
    @previous_exams = @previous_exams.order(created_at: :desc)
    @student_exams = StudentExam.includes(:exam).where(student: current_student)&.index_by(&:exam_id) || {}
  end

  def hallticket
    @name = current_student.name
  end

  def progress_report
    @student = current_student
    exams = Exam.includes(:batches).where(batches: { id: @student.batches.ids }).where(is_pr_generated: true)
    progress_report_data = ProgressReport.where(student_id: @student.id).order(exam_date: :desc)
    data = {}
    progress_report_data.each do |prd|
      key = "#{prd.exam_id || 0}-#{prd&.exam_name&.parameterize || 'default-exam'}"

      data[key] = {
        exam_date: prd.exam_date,
        present: true,
        data: {
          exam_date: prd.exam_date,
          is_imported: prd.is_imported,
          exam_name: prd.exam_name,
          data: prd.data.is_a?(Hash) ? prd.data : JSON.parse(prd.data || '{}'),
          percentage: prd.percentage,
          rank: prd.rank
        }
      }
    end
    exams.each do |exam|
      key = "#{exam.id || 0}-#{exam.name.parameterize}"
      data[key] ||= {
        exam_date: exam.show_exam_at,
        present: false,
        data: {
          exam_date: exam.show_exam_at,
          is_imported: false,
          exam_name: exam.name,
          data: {},
          percentage: 0,
          rank: nil
        }
      }
    end
    @data = Hash[data.sort_by{|k, v| v[:exam_date] || Date.today }.reverse].values
  end

  def exam
    exam = Exam.find_by(org_id: current_org.id, id: params[:id])
    @student_id = current_student.id
    if exam.blank? || exam.show_exam_at > Time.current
      flash[:error] = "invalid exam"
      redirect_to root_path
    end
    student_exam = StudentExam.find_by(student_id: current_student.id, exam_id: exam.id)
    if student_exam&.ended_at
      redirect_to "/students/summary/#{exam.id}"
    end
  end

  def instructions
  	@exam_id = params[:exam_id]
  end

  def confirmation
    @exam = Exam.find_by(id: params[:exam_id])
    if @exam.blank? || @exam.show_exam_at > Time.current
      flash[:error] = "invalid exam"
      redirect_to root_path
    end
    student_exam = StudentExam.find_by(student_id: current_student.id, exam_id: @exam.id)
    redirect_to "/students/exam/#{@exam.id}" if student_exam&.started_at.present?
  end

  def subscription
  end

  # def summary
  #   # @response = Exams::ExamSummaryService.new(params, current_student).process_summary
  #   @student_exam = StudentExam.find_by(exam_id: params[:exam_id], student_id: current_student.id)
  #   @student_exam_summaries = StudentExamSummary.includes(:section).where(student_exam_id: @student_exam.id).all
  #   @exam_id = params[:exam_id]
  #   unless @student_exam
  #     flash[:success] = @response[:message]
  #   end
  # end

  def sync
    # SyncJob.perform_async(current_student.id, params[:exam_id], params[:questions])
    SyncWorker.perform_async(current_student.id, exam_params[:exam_id], exam_params[:questions].to_h)
    return {}, status: :ok
  end

  # def submit
  #   # SyncJob.perform_async(current_student.id, params[:exam_id], params[:questions])
  #   Students::SyncService.new(current_student.id, params[:exam_id], params[:questions]).call
  #   student_exam = StudentExam.find_by(student_id: current_student.id, exam_id: params[:exam_id])
  #   head :ok unless student_exam
  #   redirect_to "/students/summary/#{student_exam.exam_id}" if student_exam.ended_at
  #   student_exam.update!(ended_at: Time.current)
  #   StudentExamScoreCalculator.new(student_exam.id).calculate
  # end

  def summary
    exam = Exam.find_by(id: params[:exam_id])
    @exam = exam
    if exam.show_result_at.blank? || exam.show_result_at <= Time.current
      @student_exam = StudentExam.find_by(exam_id: params[:exam_id], student_id: current_student.id)
      student_exam_summaries = StudentExamSummary.includes(:section).where(student_exam_id: @student_exam.id)

      ses_sync = StudentExamSync.find_by(student_id: current_student.id, exam_id: params[:exam_id])

      if student_exam_summaries.blank?
        if ses_sync
          if ses_sync.end_exam_sync
            Students::SyncService.new(current_student.id, params[:exam_id], ses_sync.sync_data).call
            StudentExamScoreCalculator.new(@student_exam.id).calculate
            # ses.destroy
          end
        end
        student_exam_summaries = StudentExamSummary.includes(:section).where(student_exam_id: @student_exam.id).all
      else
        if ses_sync && student_exam_summaries.first.updated_at < ses_sync.updated_at
          student_exam_summaries.destroy_all
          if ses_sync
            if ses_sync.end_exam_sync
              Students::SyncService.new(current_student.id, params[:exam_id], ses_sync.sync_data).call
              StudentExamScoreCalculator.new(@student_exam.id).calculate
              # ses.destroy
            end
          end
          student_exam_summaries = StudentExamSummary.includes(:section).where(student_exam_id: @student_exam.id).all
        end
      end
      @exam_id = params[:exam_id]
      es_by_section_id = exam.exam_sections.index_by(&:section_id)

      se_ids = StudentExam.where(exam_id: @exam_id).ids
      ses = StudentExamSummary.where(student_exam_id: se_ids)

      total_score, total_question, topper_total, total_marks = 0, 0, 0, 0
      time_spent = helpers.distance_of_time_in_hours_and_minutes(@student_exam.ended_at - @student_exam.started_at) rescue "Not available"
      section_data = student_exam_summaries.map do |student_exam_summary|
        topper_score = ses.where(section_id: student_exam_summary.section.id).maximum(:score)
        total_score += student_exam_summary.score
        total_question += student_exam_summary.no_of_questions
        topper_total += topper_score
        section_out_of_marks = es_by_section_id[student_exam_summary.section.id].total_marks
        total_marks += section_out_of_marks

        {
          exam_type: exam.exam_type,
          section_name: student_exam_summary.section.name,
          total_question: student_exam_summary.no_of_questions,
          correct: student_exam_summary.correct,
          incorrect: student_exam_summary.incorrect,
          input_questions_present: student_exam_summary.input_questions_present,
          correct_input_questions: student_exam_summary.correct_input_questions,
          incorrect_input_questions: student_exam_summary.incorrect_input_questions,
          not_answered: student_exam_summary.not_answered,
          score: student_exam_summary.score,
          topper_score: topper_score,
          section_out_of_marks: section_out_of_marks,
          extra_data: student_exam_summary.extra_data
        }
      end

      @summary_data = {
        is_result_processed: student_exam_summaries.present? || ses_sync&.end_exam_sync,
        total_question: total_question,
        total_score: total_score,
        time_spent: time_spent,
        section_data: section_data,
        topper_total: topper_total,
        total_marks: total_marks
      }
      @exam = exam
    end
  end

  def submit
    student_exam = StudentExam.find_by(student_id: current_student.id, exam_id: params[:exam_id])
    exam = Exam.find_by(id: params[:exam_id])
    if student_exam && student_exam.ended_at.blank?
      SyncWorker.perform_async(current_student.id, exam_params[:exam_id], exam_params[:questions].to_h, true)
      # sync_data_now(current_student.id, params[:exam_id], params[:questions])
      student_exam.update!(ended_at: Time.current)

      show_result_now = exam.show_result_at.present? ? (exam.show_result_at <= Time.current) : true
      show_result_at = exam.show_result_at&.strftime("%d-%B-%Y %I:%M %p")

      render json: { show_result_now: show_result_now, show_result_at: show_result_at }, status: :ok and return
    end
    return {error: "Exam Already submitted"}, status: 422
  end

  def sync_data_now(student_id, exam_id, questions_data)
    ses = StudentExamSync.find_by(student_id: student_id, exam_id: exam_id)
    if ses.present?
      ses.sync_data = questions_data
      ses.save
    else
      StudentExamSync.create(
        student_id: student_id,
        exam_id: exam_id,
        sync_data: questions_data
      )
    end
  end

  def profile
    @student = Student.find_by(id: current_student.id)
  end

  def update_profile
    @response = Students::UpdateStudentService.new(params, student_params).update
    set_flash
    redirect_to students_home_profile_path
  end

  private

  def exam_params
    params.permit!
    params.permit(:exam_id, questions: {})
  end

  def set_flash
    key = @response[:status] ? :success : :warning
    flash[key] = @response[:message]
  end

  def student_params
    params.require(:student).permit(
      :roll_number,
      :name,
      :mother_name,
      :date_of_birth,
      :gender,
      :ssc_marks,
      :student_mobile,
      :parent_mobile,
      :category_id,
      :address,
      :college,
      :photo)
  end

end
