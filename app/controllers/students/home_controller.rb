class Students::HomeController < Students::BaseController
  before_action :authenticate_student!, except: [:tests]
  skip_before_action :verify_authenticity_token, only: [:sync, :submit]
  layout 'student_exam_layout', only: [:exam]

  def index
    @styles = ''
  end

  def tests
    if current_student
      batch_ids = current_student.batches.map(&:id)
      exam_ids = ExamBatch.where(batch_id: batch_ids).joins(:exam).map(&:exam_id)
      @exams = Exam.where(id: exam_ids).order(created_at: :desc)
      @student_exams = StudentExam.includes(:exam).where(student: current_student)&.index_by(&:exam_id) || {}
    else
      @exams = Exam.order(created_at: :desc).all
    end
  end

  def exam
    exam = Exam.find_by(id: params[:id])
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
  end

  def subscription
  end

  def summary
    # @response = Exams::ExamSummaryService.new(params, current_student).process_summary
    @student_exam = StudentExam.find_by(exam_id: params[:exam_id], student_id: current_student.id)
    @student_exam_summaries = StudentExamSummary.includes(:section).where(student_exam_id: @student_exam.id).all
    @exam_id = params[:exam_id]
    unless @student_exam
      flash[:success] = @response[:message]
    end
  end

  def sync
    student_exam = StudentExam.find_by(student_id: current_student.id, exam_id: params[:exam_id])

    # student_exam_answer = StudentExamAnswer.find_by(student_exam_id: student_exam.id)
    # if student_exam_answer.present? && student_exam_answer.updated_at <= Time.current - 20.minues
    #   head :ok and return
    # end

    values = []
    params[:questions].each do |section, questions|
      questions.each do  |index, input_question|
        if input_question[:answerProps][:answer].to_i > 0
          student_exam_answer = StudentExamAnswer.find_by(student_exam_id: student_exam.id, question_id: input_question[:id])
          if student_exam_answer
            student_exam_answer.update!(option_id: input_question[:answerProps][:answer])
          else
            values.push("#{input_question[:id]}, #{input_question[:answerProps][:answer]}")
          end
        end
      end
  	end
    StudentExamAnswer.bulk_create(student_exam_answer_columns, values, student_exam.id)
  rescue StandardError => e
    Rails.logger.error("#{e.message} Student_id: #{current_student.id} params: #{params}")
  end

  def submit
    student_exam = StudentExam.find_by(student_id: current_student.id, exam_id: params[:exam_id])
    head :ok unless student_exam
    redirect_to "/students/summary/#{student_exam.exam_id}" if student_exam.ended_at
    student_exam.update!(ended_at: Time.current)
    StudentExamScoreCalculator.new(student_exam.id).calculate
  end

  def exam_data
    exam_id =  params[:id]
    exam = Exam.find params[:id]
    student_id = current_student.id

    student_exam = StudentExam.find_by(student_id: student_id, exam_id: exam_id)
    unless student_exam
      student_exam = StudentExam.create!(student_id: student_id, exam_id: exam_id, started_at: Time.current)
    end

    indexed_questions = exam.questions.includes(:options, :section).index_by(&:id)
    styles_by_question_id = ComponentStyle.where(
      component_type: 'Question', 
      component_id: exam.questions.ids).index_by(&:component_id)

    student_answers_by_question_id = StudentExamAnswer
      .where(student_exam_id: student_exam.id)
      .where(question_id: exam.questions.ids).index_by(&:question_id)

    questions = exam.questions.includes(:options).map do |question|
      {
    	  id: question.id,
        title: question.title,
        question_type: question.question_type,
    		options: question.options.map { |o| { id: o.id, data: o.data } }.sort_by{ |o| o[:id] },
        cssStyle: styles_by_question_id[question.id].style || '',
    		answerProps: {
          isAnswered: false,
          visited: false,
          needReview: false,
          answer: student_answers_by_question_id[question.id]&.option_id
        }
    	}
    end

    questions_by_sections = {}
    questions.shuffle.each do |question|
      db_question = indexed_questions[question[:id]]
      questions_by_sections[db_question.section.name] ||= []
      questions_by_sections[db_question.section.name] << question
    end

    render json: {
      currentQuestionIndex: questions_by_sections.keys.inject({}) { |h, k| h[k] = 0; h },
      totalQuestions: questions_by_sections.inject({}) { |h, k| h[k[0]] = k[1].size; h },
      questionsBySections: questions_by_sections,
      sections: questions_by_sections.keys,
      startedAt: student_exam.started_at,
      currentTime: DateTime.current.iso8601,
      timeInMinutes: exam.time_in_minutes,
      studentId: current_student.id,
    }
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

  def student_exam_answer_columns
    ["question_id", "option_id", "student_exam_id"]
  end
end
