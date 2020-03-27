class Students::HomeController < Students::BaseController
  before_action :authenticate_student!, except: [:index, :auto_auth]
  skip_before_action :verify_authenticity_token, only: [:sync, :submit]
  layout 'student_exam_layout', only: [:exam]

  def index
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
    @new_exams = Exam.where(id: exam_ids).where('created_at > ?', Time.now - 1.days ).order(created_at: :desc)
    @previous_exams = Exam.where(id: exam_ids).where('created_at <= ?', Time.now - 1.days ).order(created_at: :desc)
    @student_exams = StudentExam.includes(:exam).where(student: current_student)&.index_by(&:exam_id) || {}
  end

  def exam
    exam = Exam.find_by(id: params[:id])
    @student_id = current_student.id
    redirect_to root_path unless exam
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
    student_exam = StudentExam.find_by(student_id: current_student.id, exam_id: @exam.id)
    redirect_to "/students/exam/#{@exam.id}" if student_exam&.started_at.present?
  end

  def subscription
  end

  def summary
    @student_exam = StudentExam.find_by(exam_id: params[:exam_id], student_id: current_student.id)
    ses = StudentExamSync.find_by(student_id: current_student.id, exam_id: params[:exam_id])
    if ses
      Students::SyncService.new(current_student.id, params[:exam_id], ses.sync_data).call
      StudentExamScoreCalculator.new(@student_exam.id).calculate
      ses.destroy
    end
    @student_exam_summaries = StudentExamSummary.includes(:section).where(student_exam_id: @student_exam.id).all
    @exam_id = params[:exam_id]
  end

  def sync
    SyncJob.perform_async(current_student.id, params[:exam_id], params[:questions])
    return {}, status: :ok
  end

  def submit
    SyncJob.perform_async(current_student.id, params[:exam_id], params[:questions])
    student_exam = StudentExam.find_by(student_id: current_student.id, exam_id: params[:exam_id])
    head :ok unless student_exam
    student_exam.update!(ended_at: Time.current)
    return {}, status: :ok
    # Students::SyncService.new(current_student.id, params[:exam_id], params[:questions]).call
    # student_exam = StudentExam.find_by(student_id: current_student.id, exam_id: params[:exam_id])
    # head :ok unless student_exam
    # redirect_to "/students/summary/#{student_exam.exam_id}" if student_exam.ended_at
    # student_exam.update!(ended_at: Time.current)
    # StudentExamScoreCalculator.new(student_exam.id).calculate
  end

  # def exam_data
  #   exam_id = params[:id]
  #   exam = Exam.find params[:id]
  #   student_id = current_student.id

  #   student_exam = StudentExam.find_by(student_id: student_id, exam_id: exam_id)
  #   unless student_exam
  #     student_exam = StudentExam.create!(student_id: student_id, exam_id: exam_id, started_at: Time.current)
  #   end

  #   indexed_questions = exam.questions.includes(:options, :section).index_by(&:id)

  #   student_answers_by_question_id = StudentExamAnswer
  #     .where(student_exam_id: student_exam.id)
  #     .where(question_id: exam.questions.ids).index_by(&:question_id)

  #   questions = exam.questions.includes(:options).map do |question|
  #     student_answer = student_answers_by_question_id[question.id]
  #     answer = if student_answer.present?
  #                 if student_answer.ans.present?
  #                   Array.wrap(student_answer.ans)
  #                 elsif student_answer.option_id
  #                   Array.wrap(student_answer.option_id)
  #                 end
  #               end
  #     answer_props = student_answer.present? ? student_answer.question_props : {}
  #     {
  #       id: question.id,
  #       title: question.title,
  #       is_image: question.is_image,
  #       question_type: question.question_type,
  #       options: question.options.map { |o| { id: o.id, data: o.data, is_image: o.is_image } }.sort_by{ |o| o[:id] },
  #       cssStyle: "",
  #       answerProps: {
  #         isAnswered: answer_props['isAnswered'] == 'true',
  #         visited: answer_props['visited'] == 'true',
  #         needReview: answer_props['needReview'] == 'true',
  #         answer: answer
  #       }
  #     }
  #   end

  #   questions_by_sections = {}
  #   questions.shuffle.each do |question|
  #     db_question = indexed_questions[question[:id]]
  #     questions_by_sections[db_question.section.name] ||= []
  #     questions_by_sections[db_question.section.name] << question
  #   end

  #   render json: {
  #     currentQuestionIndex: questions_by_sections.keys.inject({}) { |h, k| h[k] = 0; h },
  #     totalQuestions: questions_by_sections.inject({}) { |h, k| h[k[0]] = k[1].size; h },
  #     questionsBySections: questions_by_sections,
  #     sections: questions_by_sections.keys,
  #     startedAt: student_exam.started_at,
  #     currentTime: DateTime.current.iso8601,
  #     timeInMinutes: exam.time_in_minutes,
  #     studentId: current_student.id
  #   }
  # end

  def profile
    @student = Student.find_by(id: current_student.id)
  end

  def update_profile
    @response = Students::UpdateStudentService.new(params, student_params).update
    set_flash
    redirect_to students_home_profile_path
  end

  private

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
